# frozen_string_literal: true

class Authorization < ApplicationRecord
  after_commit :set_token, on: :create

  belongs_to :user

  validates :provider, :uid, presence: true

  def confirm!
    update(confirmation_token: nil, confirm: true)
  end

  def set_token
    update(confirmation_token: Devise.friendly_token)
  end
end
