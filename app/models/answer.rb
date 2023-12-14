class Answer < ApplicationRecord
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def best?
    id == question.best_answer_id
  end

  def set_best_answer(question)
    question.update(best_answer_id: self.id)
  end
end
