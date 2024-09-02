# Taken from https://github.com/rails/rails/commit/a3bd3b5ec6448db4f7f30771a2b1aa519b6c21e9
# Can be removed when upgrading to Rails 7.0.4

module ActionCable
  module SubscriptionAdapter
    class Redis5 < Base
      prepend ChannelPrefix

      # Overwrite this factory method for Redis connections if you want to use a different Redis library than the redis gem.
      # This is needed, for example, when using Makara proxies for distributed Redis.
      cattr_accessor :redis_connector, default: ->(config) do
        ::Redis.new(config.except(:adapter, :channel_prefix))
      end

      def initialize(*)
        super
        @listener = nil
        @redis_connection_for_broadcasts = nil
      end

      def broadcast(channel, payload)
        redis_connection_for_broadcasts.publish(channel, payload)
      end

      def subscribe(channel, callback, success_callback = nil)
        listener.add_subscriber(channel, callback, success_callback)
      end

      def unsubscribe(channel, callback)
        listener.remove_subscriber(channel, callback)
      end

      def shutdown
        @listener.shutdown if @listener
      end

      def redis_connection_for_subscriptions
        redis_connection
      end

      private

      # Taken from: https://github.com/rails/rails/commit/723375147b4110ad7260962851ca4e3a7a951b47#diff-fd3e8fa393d0ae64564901f332b4dc0d12a399068d4725dd3e1bf920f13bc588R28-R31
      def identifier
        @server.config.cable[:id] ||= "ActionCable-PID-#{$$}"
      end

      def listener
        @listener || @server.mutex.synchronize { @listener ||= Listener.new(self, @server.event_loop) }
      end

      def redis_connection_for_broadcasts
        @redis_connection_for_broadcasts || @server.mutex.synchronize do
          @redis_connection_for_broadcasts ||= redis_connection
        end
      end

      def redis_connection
        self.class.redis_connector.call(@server.config.cable.symbolize_keys.merge(id: identifier))
      end

      class Listener < SubscriberMap
        def initialize(adapter, event_loop)
          super()

          @adapter = adapter
          @event_loop = event_loop

          @subscribe_callbacks = Hash.new { |h, k| h[k] = [] }
          @subscription_lock = Mutex.new

          @subscribed_client = nil

          @when_connected = []

          @thread = nil
        end

        def listen(conn)
          conn.without_reconnect do
            original_client = extract_subscribed_client(conn)

            conn.subscribe("_action_cable_internal") do |on|
              on.subscribe do |chan, count|
                @subscription_lock.synchronize do
                  if count == 1
                    @subscribed_client = original_client

                    until @when_connected.empty?
                      @when_connected.shift.call
                    end
                  end

                  if callbacks = @subscribe_callbacks[chan]
                    next_callback = callbacks.shift
                    @event_loop.post(&next_callback) if next_callback
                    @subscribe_callbacks.delete(chan) if callbacks.empty?
                  end
                end
              end

              on.message do |chan, message|
                broadcast(chan, message)
              end

              on.unsubscribe do |chan, count|
                if count == 0
                  @subscription_lock.synchronize do
                    @subscribed_client = nil
                  end
                end
              end
            end
          end
        end

        def shutdown
          @subscription_lock.synchronize do
            return if @thread.nil?

            when_connected do
              @subscribed_client.unsubscribe
              @subscribed_client = nil
            end
          end

          Thread.pass while @thread.alive?
        end

        def add_channel(channel, on_success)
          @subscription_lock.synchronize do
            ensure_listener_running
            @subscribe_callbacks[channel] << on_success
            when_connected { @subscribed_client.subscribe(channel) }
          end
        end

        def remove_channel(channel)
          @subscription_lock.synchronize do
            when_connected { @subscribed_client.unsubscribe(channel) }
          end
        end

        def invoke_callback(*)
          @event_loop.post { super }
        end

        private
        def ensure_listener_running
          @thread ||= Thread.new do
            Thread.current.abort_on_exception = true

            conn = @adapter.redis_connection_for_subscriptions
            listen conn
          end
        end

        def when_connected(&block)
          if @subscribed_client
            block.call
          else
            @when_connected << block
          end
        end

        if ::Redis::VERSION < "5"
          class SubscribedClient
            def initialize(raw_client)
              @raw_client = raw_client
            end

            def subscribe(*channel)
              send_command("subscribe", *channel)
            end

            def unsubscribe(*channel)
              send_command("unsubscribe", *channel)
            end

            private
            def send_command(*command)
              @raw_client.write(command)

              very_raw_connection =
                @raw_client.connection.instance_variable_defined?(:@connection) &&
                  @raw_client.connection.instance_variable_get(:@connection)

              if very_raw_connection && very_raw_connection.respond_to?(:flush)
                very_raw_connection.flush
              end
              nil
            end
          end

          def extract_subscribed_client(conn)
            raw_client = conn.respond_to?(:_client) ? conn._client : conn.client
            SubscribedClient.new(raw_client)
          end
        else
          def extract_subscribed_client(conn)
            conn
          end
        end
      end
    end
  end
end