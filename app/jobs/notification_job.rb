# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :default

  def perform(object)
    Notification.new.send_notification(object)
  end
end
