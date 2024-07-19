# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable
  include Attachable
  include Rewardable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  def best?
    id == question.best_answer_id
  end

  def set_best_answer(question)
    question.update(best_answer_id: id)
    question.reward&.update(answer: self)
  end

  private

  def subscriber_notification
    NotificationJob.perform_later(self)
  end
end
