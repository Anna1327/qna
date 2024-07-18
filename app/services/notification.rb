# frozen_string_literal: true

class Notification
  def send_notification(answer)
    SubscriberNotificationMailer.send_notification(answer).deliver_later
  end
end