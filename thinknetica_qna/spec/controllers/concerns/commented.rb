require 'rails_helper'

shared_examples_for 'commented' do
  let(:comment) { create(:comment) }
  describe 'POST #create_comment' do
    before { sign_in(subject.user) }
    context 'check valid conditions' do
      it 'creates a new comment with parameters' do
        expect { post :create_comment, id: subject, comment: attributes_for(:comment), format: :json }.to change(subject.comments, :count).by(1)
      end
    end
    context 'check invalid conditions' do
      it 'fails with an incomplete comment' do
        expect { post :create_comment, id: subject, comment: { body: '' }, format: :json }.to_not change(subject.comments, :count)
      end
    end
  end
end
