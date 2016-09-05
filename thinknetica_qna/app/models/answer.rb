# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, :question_id, presence: true
  validates :user_id, :body, presence: true

  def make_best
    Answer.transaction do
      updated_count = question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless updated_count == question.answers.count
      update!(best: true)
    end
  end
end
