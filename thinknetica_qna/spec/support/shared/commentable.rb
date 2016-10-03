require 'rails_helper'

shared_examples_for 'commentable' do
  before { sign_in(object.user) }
  context 'check valid conditions' do
    it 'creates a new comment with parameters' do
      expect { post :create, id.to_sym => object, comment: attributes_for(:comment), format: :json }.to change(object.comments, :count).by(1)
    end
  end
  context 'check invalid conditions' do
    it 'fails with an incomplete comment' do
      expect { post :create, id.to_sym => object, comment: { body: '' }, format: :json }.to_not change(object.comments, :count)
    end
  end
  context 'PrivatePub' do
    it 'publishes a new question' do
      expect(PrivatePub).to receive(:publish_to).with("/questions/#{publish_object_id}/comments", anything)
      post :create, id.to_sym => object, comment: attributes_for(:comment), format: :json
    end
  end
end
