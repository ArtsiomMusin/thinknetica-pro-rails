# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, :question_id, presence: true

  def belongs_to_user(user)
    current_user = User.find(user)
    current_user.answers.include?(self) ? true : false
  end
end
