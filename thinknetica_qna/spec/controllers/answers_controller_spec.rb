require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question_with_answer) { create(:question, answers: [answer]) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  describe 'GET #new' do
    before { sign_in(question.user) }
    before { get :new, question_id: question }
    it 'creates a new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { sign_in(question.user) }
    context 'check valid conditions' do
      it 'creates a new answer with parameters' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end
      it 'renders show after creating a new answer' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'check invalid conditions' do
      it 'fails with an incomplete answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 'renders new again' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to redirect_to new_question_answer_path(question)
      end
    end
  end
  describe 'GET #destroy' do
    before { sign_in(question_with_answer.user) }
    context 'check for one question' do
      it 'removes an answer' do
        expect { get :destroy, question_id: question_with_answer, id: answer }.to change(question_with_answer.answers, :count).by(-1)
      end
      it 'renders index' do
        get :destroy, question_id: question_with_answer, id: answer
        expect(response).to redirect_to question_with_answer
      end
    end
  end

end
