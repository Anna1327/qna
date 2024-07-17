class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :best_answer_id, :created_at, :updated_at, :files
  has_many :comments
  has_many :links
  belongs_to :author, class_name: 'User'

  def files
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end
