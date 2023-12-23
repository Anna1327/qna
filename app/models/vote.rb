class Vote < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validate :validation_by_author

  def liked
    self.destroy if self.value == -1
  end

  def disliked
    self.destroy if self.value == 1
  end

  def validation_by_author
    errors.add :question, "Can't vote for your own #{votable.class.name}" if author&.author_of?(votable)
  end
end
