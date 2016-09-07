# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments,
    reject_if: proc { |attributes| attributes['file'].blank? },
    allow_destroy: true

  def make_best
    Answer.transaction do
      updated_count = question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless updated_count == question.answers.count
      update!(best: true)
    end
  end
end
