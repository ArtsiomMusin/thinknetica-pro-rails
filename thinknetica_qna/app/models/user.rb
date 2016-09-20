class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations

  def author_of?(entity)
    id == entity.user_id
  end

  def can_vote?(entity)
    !author_of?(entity) && !voted?(entity)
  end

  def can_reject_vote?(entity)
    !author_of?(entity) && voted?(entity)
  end

  def find_vote(entity)
    entity.votes.where(user: self).first
  end

  def voted?(entity)
    !entity.votes.where(user: self).empty?
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
