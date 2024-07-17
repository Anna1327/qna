class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title
  has_many :answers, serializer: AnswersSerializer
  belongs_to :author, class_name: 'User'

  def short_title
    object.title.truncate(7)
  end
end

