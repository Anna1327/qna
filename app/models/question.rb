class Question < ApplicationRecord
  include Linkable
  include Attachable
  include Rewardable
  include Votable

  has_many :answers, dependent: :destroy

  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
