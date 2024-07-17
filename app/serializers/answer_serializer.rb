class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :correct, :question_id, :created_at, :updated_at, :files
  has_many :comments
  has_many :links
  belongs_to :question
  belongs_to :author, class_name: 'User'
end


