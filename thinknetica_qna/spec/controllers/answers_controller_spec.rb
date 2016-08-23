require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question_with_answer) { create(:question, answers: [answer]) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  describe 'GET #index' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 2, question: question) }
    before { get :index, question_id: question }
    it 'gets all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end
    it 'renders index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, question_id: question_with_answer, id: answer }
    it 'shows one specific answer' do
      expect(assigns(:answer)).to eq answer
    end
    it 'renders show' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question }
    it 'creates a new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
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
        expect(response).to render_template :new
      end
    end
  end

end
