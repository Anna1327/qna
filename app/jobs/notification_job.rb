# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :default

  def perform(object)
    SubscriberNotificationMailer.send_notification(object).deliver_later
  end
end
