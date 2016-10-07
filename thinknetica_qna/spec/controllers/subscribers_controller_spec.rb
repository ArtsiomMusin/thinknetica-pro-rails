require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  describe 'POST #create' do
    before { sign_in(user) }
    it 'subscribes the current user to the question' do
      expect { post :create, question_id: question, format: :js }.to change(question.subscribers, :count).by(1)
    end
    before { post :create, question_id: question, format: :js }
    it 'creates a new subscriber as the current user' do
      expect(user.id).to eq assigns(:question).subscribers.first.user_id
    end
    it 'renders show after creating a new question' do
      expect(response).to render_template :create
    end
  end
end
