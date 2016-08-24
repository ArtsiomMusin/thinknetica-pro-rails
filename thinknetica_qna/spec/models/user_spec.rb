# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }
  context 'validates author_of? method' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    it 'has a question' do
      expect(question.user.author_of?(question)).to be true
    end
    it 'does not have a question' do
      expect(user.author_of?(question)).to be false
    end
    it 'has an answer' do
      expect(answer.user.author_of?(answer)).to be true
    end
    it 'does not have an answer' do
      expect(user.author_of?(answer)).to be false
    end
  end

end
