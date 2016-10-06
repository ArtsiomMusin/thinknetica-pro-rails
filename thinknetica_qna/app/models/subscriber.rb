class Subscriber < ApplicationRecord
  belongs_to :question
  validates :user_id, presence: true
end
