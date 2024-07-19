# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true

  has_one_attached :image

  validates :title, :image, presence: true
  validate :validate_image

  private

  def validate_image
    return errors.add :image, I18n.t('rewards.errors.blank') unless image.attached?

    errors.add :image, I18n.t('rewards.errors.only_image') unless image.blob.content_type.start_with?('image/')
  end
end
