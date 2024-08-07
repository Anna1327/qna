# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :best_answer_id, :created_at, :updated_at, :files
  has_many :comments
  has_many :links
  belongs_to :author, class_name: 'User'
end
