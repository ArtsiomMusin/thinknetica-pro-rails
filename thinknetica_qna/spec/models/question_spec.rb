# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }
  it { should have_many(:votes) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }
  it { should accept_nested_attributes_for(:votes).allow_destroy(true) }

  context 'validates methods' do
    let(:question) { create(:question) }
    it 'calculates the vote rating' do
      question.votes.create(positive: true, user: question.user)
      question.votes.create(positive: true, user: question.user)
      question.votes.create(positive: true, user: question.user)
      question.votes.create(positive: false, user: question.user)
      expect(question.vote_rating).to eq('+2')
    end
  end
end
