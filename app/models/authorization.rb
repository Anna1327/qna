class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true

  def set_token
    update(confirmation_token: Devise.friendly_token)
  end

  def confirmed?
    confirmation_token.nil?
  end

  def confirm!
    update(confirmation_token: nil)
  end
end
