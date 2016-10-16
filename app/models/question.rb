# frozen_string_literal: true
class Question < ApplicationRecord
  include HasUser
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  validates :title, :body, presence: true

  after_create :subscribe_author

  scope :daily_created, ->() { where(created_at: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day) }

  def find_subscription(user)
    self.subscriptions.where(user_id: user.id).first
  end

  def subscribe_author
    self.subscriptions.create(user_id: user_id) if self.valid?
  end
end
