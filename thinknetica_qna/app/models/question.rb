# frozen_string_literal: true
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  validates :title, :body, presence: true

  def belongs_to_user(user)
    current_user = User.find(user)
    current_user.questions.include?(self) ? true : false
  end
end
