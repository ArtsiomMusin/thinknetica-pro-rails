require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  describe 'test methods' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    it 'adds answers to a question' do
      question.add_answer(answer)
      expect(question.answers.first).to eq answer
    end
  end
end
