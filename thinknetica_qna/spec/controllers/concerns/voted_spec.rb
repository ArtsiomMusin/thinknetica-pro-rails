require 'rails_helper'

shared_examples_for 'voted' do
  let(:user) { create(:user) }
  describe 'PUT #vote' do
    context 'authenticated user conditions' do
      before { sign_in(user) }
      it 'votes for the model' do
        put :vote_yes, id: model, format: :json
        expect(model.votes.first.positive).to be true
      end
      it 'rejects the vote' do
        model.votes.create(positive: true, user: user)
        expect { put :reject_vote, id: model, format: :json }.to change(model.votes, :count).by(-1)
      end
    end

    context 'another conditions' do
      it 'does not change the vote count' do
        sign_in(model.user)
        expect { put :vote_no, id: model, format: :json }.to_not change(model.votes, :count)
      end
    end
  end

end

describe QuestionsController, type: :controller do
  let(:model) { create(:question) }
  it_should_behave_like 'voted'
end

describe AnswersController, type: :controller do
  let(:model) { create(:answer) }
  it_should_behave_like 'voted'
end
