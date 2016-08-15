class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def add_answer(answer)
    answers.push(answer)
  end
end
