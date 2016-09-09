# frozen_string_literal: true
class Question < ApplicationRecord
  include HasUser
  include Attachable

  has_many :answers, dependent: :destroy
  validates :title, :body, presence: true
end
