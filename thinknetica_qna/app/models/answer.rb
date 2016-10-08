# frozen_string_literal: true
class Answer < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  validates :body, :question_id, presence: true

  after_create :send_new_answer_notifications

  def make_best
    Answer.transaction do
      updated_count = question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless updated_count == question.answers.count
      update!(best: true)
    end
  end

  private

  def send_new_answer_notifications
    self.question.subscriptions.each do |subscription|
      user = User.find(subscription.user_id)
      AnswerMailer.digest(user).deliver_later
    end
  end
end
