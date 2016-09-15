require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:comment) { create(:comment) }
  describe 'POST #create' do
    before { sign_in(question.user) }
    context 'check valid conditions' do
      it 'creates a new answer with parameters' do
        expect { post :create, commentable_id: question, comment: attributes_for(:comment), format: :js }.to change(question.comments, :count).by(1)
      end
      it 'renders create template after creating a new answer' do
        post :create, commentable_id: question, comment: attributes_for(:comment), format: :js
        expect(response).to render_template 'comments/create'
      end
    end
    context 'check invalid conditions' do
      it 'fails with an incomplete comment' do
        expect { post :create, commentable_id: question, comment: { body: '' }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template again' do
        post :create, commentable_id: question, comment: { body: '' }, format: :js
        expect(response).to render_template 'answers/create'
      end
    end
  end
end
