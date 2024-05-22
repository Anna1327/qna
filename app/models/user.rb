class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]
  
  has_many :authorizations, dependent: :destroy
  has_many :questions, class_name: 'Question', foreign_key: 'author_id', dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: 'author_id', dependent: :destroy
  has_many :rewards, through: :answers
  has_many :votes, class_name: 'Vote', foreign_key: 'author_id'
  has_many :comments, class_name: 'Comment', foreign_key: 'author_id'

  def author_of?(resource)
    self.id == resource.author_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end
end
