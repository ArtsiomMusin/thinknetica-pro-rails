# frozen_string_literal: true
class Answer < ApplicationRecord
  include HasUser
  include Attachable
  include Votable

  belongs_to :question
  validates :body, :question_id, presence: true

  def make_best
    Answer.transaction do
      updated_count = question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless updated_count == question.answers.count
      update!(best: true)
    end
  end
end
