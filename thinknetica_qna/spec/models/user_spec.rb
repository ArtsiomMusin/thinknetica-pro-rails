# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations) }

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

  context '#subscribed?' do
    let(:user_subscribed) { create(:user) }
    let(:subscription) { create(:subscription, user_id: user_subscribed.id) }
    let(:question_subscribed) { create(:question, subscriptions: [subscription]) }
    it 'returns true if the user is currently subscription to the question' do
      expect(user_subscribed).to be_subscribed(question_subscribed)
    end
    it 'returns false if the user is not currently subscription to the question' do
      expect(user).to_not be_subscribed(question)
    end
  end

  describe 'votes methods' do
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

  describe '.find_for_oauth' do
    context 'facebook'
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

      context 'user already has authorization' do
        it 'returns the user' do
          user.authorizations.create(provider: 'facebook', uid: '123456')
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not have authorization' do
        context 'user already exists' do
          let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
          it 'does not create a new user' do
            expect { User.find_for_oauth(auth) }.to_not change(User, :count)
          end

          it 'creates authorization for the user' do
            expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count)
          end

          it 'creates authorization with right provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first
            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'returns the user' do
            expect(User.find_for_oauth(auth)).to eq user
          end
        end

        context 'user does not exist' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'fake@mail.com' }) }

          it 'creates a new user' do
            expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
          end
          it 'returns a new user' do
            expect(User.find_for_oauth(auth)).to be_a(User)
          end
          it 'fills a user email' do
            user = User.find_for_oauth(auth)
            expect(user.email).to be_eql(auth.info.email)
          end
          it 'creates authorization for the user' do
            user = User.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end
          it 'creates authorization with right provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first
            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end
      end
    end
    context 'twitter' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }

      context 'user already has authorization' do
        it 'returns the user' do
          user.authorizations.create(provider: 'twitter', uid: '123456')
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

  describe '.build_from_omniauth_params' do
    it 'builds a new user' do
      params = { user: { email: 'fake@mail.com' } }
      auth = {
        'provider' => 'twitter', 'uid' => 123456,
        'user_password' => '123456'
      }
      expect { User.build_from_omniauth_params(params, auth) }.to change(User, :count).by(1)
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }
    let(:questions) { create_list(:question, 2, user: users.first) }
    it 'sends the daily digest with latest questions created' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original }
      User.send_daily_digest
    end
  end
end
