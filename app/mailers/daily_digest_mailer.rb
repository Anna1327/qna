# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  attr_reader :question

  def digest(user)
    @questions = Question.where(created_at: (Time.now - 1.day)..Time.now)
    mail to: user.email
  end
end
