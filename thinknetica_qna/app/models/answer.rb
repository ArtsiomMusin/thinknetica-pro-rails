# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, :question_id, presence: true
  validates :user_id, :body, presence: true
  validates_inclusion_of :best, in: [true, false]
end
