# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }
  context 'validates make_best method' do
    let(:question) { create(:question) }
    before { create(:answer, question: question) }
    it 'sets the best answer' do
      question.answers.first.make_best
      expect(question.answers.first.best).to be true
    end
  end
end
