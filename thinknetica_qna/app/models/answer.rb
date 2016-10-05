# frozen_string_literal: true
class Answer < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  validates :body, :question_id, presence: true

  after_create :notify_question_author

  def make_best
    Answer.transaction do
      updated_count = question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless updated_count == question.answers.count
      update!(best: true)
    end
  end

  private

  def notify_question_author
    AnswerMailer.delay.digest(self.question.user)
  end
end
