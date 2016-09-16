# frozen_string_literal: true
class Question < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  validates :title, :body, presence: true

  def channel_name
    "/questions/#{id}/comments"
  end
end
