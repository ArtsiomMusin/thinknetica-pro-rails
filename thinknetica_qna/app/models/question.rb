class Question < ApplicationRecord
  validates :title, :body, presence: true
  has_many :answers, foreign_key: 'answer_id'
end
