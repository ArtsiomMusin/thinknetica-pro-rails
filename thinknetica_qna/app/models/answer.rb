# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, :question_id, presence: true
  validates :user_id, :body, presence: true

  def make_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update_attribute(:best, true)
    end
  end
end
