require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question_with_answer) { create(:question, answers: [answer]) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:best_answer) { create(:best_answer) }

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
        expect { delete :destroy, id: question.answers.first, format: :js }.to change(question.answers, :count).by(-1)
      end
      it 'renders destroy template' do
        delete :destroy, id: question.answers.first, format: :js
        expect(response).to render_template 'answers/destroy'
      end
    end
    context 'remove an answer by another user' do
      let(:user) { create(:user) }
      it 'removes an answer from another user' do
        sign_in(user)
        expect { delete :destroy, id: question_with_answer.answers.first, format: :js }.to_not change(question_with_answer.answers, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(answer.user) }
    context 'valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end
      before { patch :update, id: answer, answer: { body: 'new body' }, format: :js }
      it 'changes attributes for the answer' do
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      it 'does not change the answer' do
        patch :update, id: answer, answer: { body: '' }, format: :js
        expect(answer.body).to eq 'AnswerText'
      end
    end
  end

  describe 'PUT #mark_best' do
    context 'author conditions' do
      let(:answer) { create(:answer, question: question, user: question.user) }
      before { sign_in(answer.user) }
      it 'marks the requested answer to be best' do
        put :mark_best, id: answer, format: :js
        answer.reload
        expect(answer.best).to eq true
      end
      it 'renders best template' do
        put :mark_best, id: answer, format: :js
        answer.reload
        expect(response).to render_template 'answers/mark_best'
      end
      # it 'does not change the best answer' do
      #   put :mark_best, id: answer, answer: { best: nil }, format: :js
      #   answer.reload
      #   expect(answer.best).to eq false
      # end
    end

    context 'non-another conditions' do
      let(:user) { create(:user) }
      it 'does not change the best answer' do
        sign_in(user)
        put :mark_best, id: answer, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end
end
