class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  def best?
    id == question.best_answer_id
  end

  def set_best_answer(question)
    question.update(best_answer_id: self.id)
  end
end
