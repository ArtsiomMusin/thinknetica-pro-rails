# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  context 'validates methods' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    it 'has a question' do
      expect(question.user).to be_author_of(question)
    end
    it 'does not have a question' do
      expect(user).to_not be_author_of(question)
    end
    it 'can vote for a question' do
      expect(user.can_vote?(question)).to be true
    end
    it 'cannot vote for a question' do
      question.votes.create(positive: true, user: question.user)
      expect(question.user.can_vote?(question)).to be false
    end
    it 'cannot vote for the question voted' do
      question.votes.create(positive: true, user: user)
      expect(user.can_vote?(question)).to be false
    end
  end

end
