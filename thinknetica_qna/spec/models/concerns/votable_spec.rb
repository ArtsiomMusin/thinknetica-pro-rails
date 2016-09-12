require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }
  describe 'check methods' do
    it 'validates vote_rating method' do
      model.votes.create(positive: true, user: model.user)
      model.votes.create(positive: true, user: model.user)
      model.votes.create(positive: true, user: model.user)
      model.votes.create(positive: false, user: model.user)
      expect(model.vote_rating).to eq('+2')
    end
    it 'validates voted? method by another user' do
      model.votes.create(positive: true, user: user)
      expect(model.voted?(model.user)).to be false
    end
    it 'validates voted? method' do
      model.votes.create(positive: true, user: model.user)
      expect(model.voted?(model.user)).to be true
    end
  end
  it { should have_many(:votes) }
end

describe Question do
  it_should_behave_like 'votable'
end

describe Answer do
  it_should_behave_like 'votable'
end
