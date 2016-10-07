require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Attachment }
    it { should be_able_to :read, Vote }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to :manage, :all}
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create, Subscriber }
    end

    context 'update' do
      it { should be_able_to :update, create(:question, user: user) }
      it { should_not be_able_to :update, create(:question, user: other_user) }
      it { should be_able_to :update, create(:answer, user: user) }
      it { should_not be_able_to :update, create(:answer, user: other_user) }
    end

    context 'votes' do
      # huh too much duplication here?
      it { should_not be_able_to :vote_yes, create(:question, user: user), user: user }
      it { should be_able_to :vote_yes, create(:question, user: other_user), user: user }
      it { should_not be_able_to :vote_no, create(:question, user: user), user: user }
      it { should be_able_to :vote_no, create(:question, user: other_user), user: user }
      it { should_not be_able_to :reject_vote, create(:question, user: user), user: user }
      it { should be_able_to :reject_vote, create(:question, user: other_user), user: user }

      it { should_not be_able_to :vote_yes, create(:answer, user: user), user: user }
      it { should be_able_to :vote_yes, create(:answer, user: other_user), user: user }
      it { should_not be_able_to :vote_no, create(:answer, user: user), user: user }
      it { should be_able_to :vote_no, create(:answer, user: other_user), user: user }
      it { should_not be_able_to :reject_vote, create(:answer, user: user), user: user }
      it { should be_able_to :reject_vote, create(:answer, user: other_user), user: user }
    end

    context 'mark best' do
      it { should be_able_to :mark_best, create(:answer, question: question, user: question.user)}
      it { should_not be_able_to :mark_best, create(:answer, user: other_user) }
    end

    context 'destroy' do
      it { should be_able_to :destroy, Question }
      it { should be_able_to :destroy, Answer }
      it { should be_able_to :destroy, Attachment }
      it { should be_able_to :destroy, Subscriber }
    end

    it { should be_able_to :build_by_email, User }

    context 'profiles' do
      it { should be_able_to :get_all, :profile }
      it { should be_able_to :get_me, :profile }
    end
  end
end
