class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions
  has_many :answers
  has_many :votes

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
end
