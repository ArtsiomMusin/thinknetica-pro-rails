require 'rails_helper'

shared_examples_for 'voted' do
  let(:user) { create(:user) }
  describe 'PUT #vote' do
    context 'authenticated user conditions' do
      before { sign_in(user) }
      it 'votes for the subject' do
        put :vote_yes, id: subject, format: :json
        expect(subject.votes.first.state).to be 1
      end
      it 'rejects the vote' do
        subject.votes.create(state: 1, user: user)
        expect { put :reject_vote, id: subject, format: :json }.to change(subject.votes, :count).by(-1)
      end
    end

    context 'another conditions' do
      it 'does not change the vote count' do
        sign_in(subject.user)
        expect { put :vote_no, id: subject, format: :json }.to_not change(subject.votes, :count)
      end
    end
  end
end
