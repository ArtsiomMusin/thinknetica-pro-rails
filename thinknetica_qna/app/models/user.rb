class User < ApplicationRecord
  include HasVotes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions
  has_many :answers

  def author_of?(entity)
    id == entity.user_id
  end

  def can_vote?(entity)
    !author_of?(entity) && !entity.voted?(self)
  end
end
