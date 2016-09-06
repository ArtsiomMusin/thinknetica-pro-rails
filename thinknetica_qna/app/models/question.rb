# frozen_string_literal: true
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  # it seems attachments are not created w/o inverse_of
  # https://www.viget.com/articles/exploring-the-inverse-of-option-on-rails-model-associations
  has_many :attachments, as: :attachable#, inverse_of: :question
  belongs_to :user

  validates :title, :body, presence: true
  validates :user_id, :body, presence: true

  accepts_nested_attributes_for :attachments
end
