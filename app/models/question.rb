# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Attachable
  include Rewardable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscribers, dependent: :destroy

  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true

  def other_answers
    answers.where.not(id: best_answer_id)
  end

  after_create :calculate_reputation

  private

  def calculate_reputation
    ReputationJob.perform_now(self)
  end
end
