# frozen_string_literal: true
require 'rails_helper'
require_relative 'concerns/votable'
require_relative 'concerns/has_user'
require_relative 'concerns/attachable'
require_relative 'concerns/commentable'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }

  let(:question) { create(:question) }
  describe '#make_best?' do
    before { create(:answer, question: question) }
    it 'sets the best answer' do
      question.answers.first.make_best
      expect(question.answers.first.best).to be true
    end
  end

  describe '#send_new_answer_notifications' do
    let(:users) { create_list(:user, 2) }
    before do
      question.subscriptions = []
      users.each { |user| question.subscriptions << create(:subscription, user_id: user.id) }
    end
    it 'sends emails to all subscribers' do
      users.each { |user| expect(AnswerMailer).to receive(:digest).with(user).and_call_original }
      create(:answer, question: question)
    end
  end

  context 'concern checks' do
    it_behaves_like 'votable'
    it_behaves_like 'has_user'
    it_behaves_like 'attachable'
    it_behaves_like 'commentable'
  end
end
