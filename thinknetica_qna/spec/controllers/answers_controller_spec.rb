require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question_with_answer) { create(:question, answers: [answer]) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    before { sign_in(question.user) }
    context 'check valid conditions' do
      it 'creates a new answer with parameters' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end
      before { post :create, question_id: question, answer: attributes_for(:answer), format: :js }
      it 'creates a new answer with the right user' do
        expect(assigns(:answer).user_id).to eq question.user_id
      end
      it 'renders create template after creating a new answer' do
        expect(response).to render_template 'answers/create'
      end
    end
    context 'check invalid conditions' do
      it 'fails with an incomplete answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template again' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template 'answers/create'
      end
    end
  end
  describe 'GET #destroy' do
    before do
      sign_in(question.user)
      question.answers << create(:answer, question: question, user: question.user)
    end
    context 'check for one question' do
      it 'removes an answer' do
        expect { delete :destroy, id: question.answers.first }.to change(question.answers, :count).by(-1)
      end
      it 'renders question' do
        delete :destroy, id: question.answers.first
        expect(response).to redirect_to question_path(question)
      end
    end
    context 'remove an answer by another user' do
      let(:user) { create(:user) }
      it 'removes an answer from another user' do
        sign_in(user)
        expect { delete :destroy, id: question_with_answer.answers.first }.to_not change(question_with_answer.answers, :count)
      end
    end
  end
end
