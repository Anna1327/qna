class Answer < ApplicationRecord
  include Linkable

  has_many_attached :files
  has_one :reward, dependent: :destroy

  belongs_to :question
  belongs_to :author, class_name: 'User'

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :body, presence: true

  def best?
    id == question.best_answer_id
  end

  def set_best_answer(question)
    question.update(best_answer_id: self.id)
    question.reward&.update(answer: self)
  end
end
