# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  context '#author_of?' do
    it 'returns true if it is the author of a question' do
      expect(question.user).to be_author_of(question)
    end
    it 'returns false if it is not the author of a question' do
      expect(user).to_not be_author_of(question)
    end
  end
  context '#can_vote?' do
    it 'returns true if can vote for a question' do
      expect(user).to be_can_vote(question)
    end
    it 'returns false if cannot vote for a question' do
      question.votes.create(state: 1, user: question.user)
      expect(question.user).to_not be_can_vote(question)
    end
    it 'cannot vote for the question voted' do
      question.votes.create(state: 1, user: user)
      expect(user).to_not be_can_vote(question)
    end
  end

  context '#can_reject_vote?' do
    it 'cannot reject a vote which is not voted by the user' do
      expect(user).to_not be_can_reject_vote(question)
    end
    it 'rejects a vote for the question voted' do
      question.votes.create(state: 1, user: user)
      expect(user).to be_can_reject_vote(question)
    end
  end

  context '#find_vote' do
    it 'finds a vote for the question' do
      vote = question.votes.create(state: 1, user: question.user)
      expect(vote.id).to be question.user.find_vote(question).id
    end
    it 'cannot find a vote for the question' do
      expect(nil).to be user.find_vote(question)
    end
  end

  context '#voted?' do
    it 'checks the question was voted by another user' do
      question.votes.create(state: 1, user: user)
      expect(question.user).to_not be_voted(question)
    end
    it 'checks the question was voted' do
      question.votes.create(state: 1, user: question.user)
      expect(question.user).to be_voted(question)
    end
  end
end
