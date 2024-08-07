# frozen_string_literal: true

class User < ApplicationRecord
  enum role: {
    admin: 1,
    user: 0
  }, _default: :user

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :authorizations, dependent: :destroy
  has_many :questions, class_name: 'Question', foreign_key: 'author_id', dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: 'author_id', dependent: :destroy
  has_many :subscribers, class_name: 'Subscriber', foreign_key: 'author_id', dependent: :destroy

  has_many :rewards, through: :answers
  has_many :votes, class_name: 'Vote', foreign_key: 'author_id'
  has_many :comments, class_name: 'Comment', foreign_key: 'author_id'

  def author_of?(resource)
    id == resource.author_id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def email_confirmed?(auth)
    authorizations.find_by(uid: auth.uid, provider: auth.provider)&.confirm?
  end
end
