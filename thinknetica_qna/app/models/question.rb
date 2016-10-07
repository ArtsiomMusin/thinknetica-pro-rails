# frozen_string_literal: true
class Question < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscribers, dependent: :destroy
  validates :title, :body, presence: true

  scope :daily_created, ->() { where('created_at >= ?', Time.now - 1.day) }
  
  def extract_subscriber(user)
    self.subscribers.where(user_id: user.id).first
  end
end
