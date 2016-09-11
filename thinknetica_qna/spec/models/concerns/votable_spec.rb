require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  describe 'validates methods' do
    it 'validates vote_rating method' do
      model.votes.create(positive: true, user: model.user)
      model.votes.create(positive: true, user: model.user)
      model.votes.create(positive: true, user: model.user)
      model.votes.create(positive: false, user: model.user)
      expect(model.vote_rating).to eq('+2')
    end
    it { should have_many(:votes) }
  end
end

describe Question do
  it_should_behave_like 'votable'
end

describe Answer do
  it_should_behave_like 'votable'
end
