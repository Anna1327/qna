# frozen_string_literal: true

class SubscriberNotificationMailer < ApplicationMailer
  def send_notification(answer)
    @question = answer.question
    mail(to: current_user.email,
      subject: "There is a new answer to the '#{@question.title}' question")
  end
end