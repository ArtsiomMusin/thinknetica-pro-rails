# frozen_string_literal: true
require 'rails_helper'
require_relative 'concerns/votable'
require_relative 'concerns/has_user'
require_relative 'concerns/attachable'
require_relative 'concerns/commentable'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscribers).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  context 'concern checks' do
    it_behaves_like 'votable'
    it_behaves_like 'has_user'
    it_behaves_like 'attachable'
    it_behaves_like 'commentable'
  end

  context '#extract_subscriber' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:subscriber) { create(:subscriber, user_id: user.id) }
    let(:question) { create(:question, subscribers: [subscriber]) }

    it 'extracts the subscriber by the user' do
      expect(question.extract_subscriber(user).id).to be subscriber.id
    end

    it 'cannot extract the subscriber from the user with no subscribers' do
      expect(question.extract_subscriber(another_user)).to be_nil
    end
  end
end
