require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }
    it 'gets all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }
    it 'shows one specific question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders index' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'creates a new question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders new' do
      expect(response).to render_template :new
    end
  end

  let(:user) { create(:user) }
  describe 'POST #create' do
    sign_in_user
    context 'check valid conditions' do
      let(:question_with_answer) { build(:question_with_answer) }
      it 'creates a new question with parameters' do
        expect { post :create, user_id: user, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'renders show after creating a new question' do
        post :create, user_id: user, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'check invalid conditions' do
      it 'fails with an incomplete question' do
        expect { post :create, user_id: user, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 'renders new again' do
        post :create, user_id: user, question: attributes_for(:invalid_question)
        expect(response).to redirect_to new_question_path
      end
    end
  end

  describe 'GET #destroy' do
    sign_in_user
    context 'check for one question' do
      it 'removes a question' do
        question # wtf? no question yet?
        expect { get :destroy, user_id: user, id: question }.to change(Question, :count).by(-1)
      end
      it 'renders index' do
        get :destroy, user_id: user, id: question
        expect(response).to redirect_to root_path
      end
    end
    context 'remove answer with questions'
  end
end
