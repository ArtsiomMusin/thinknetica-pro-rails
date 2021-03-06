require 'rails_helper'
require_relative 'concerns/voted'

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
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      before { post :create, question: attributes_for(:question) }
      it 'creates a new question with the right user' do
        expect(@user.id).to eq assigns(:question).user_id
      end
      it 'renders show after creating a new question' do
        expect(response).to redirect_to assigns(:question)
      end
      it 'adds the subscription for the question author' do
        expect(assigns(:question).subscriptions.first.user_id).to eq assigns(:question).user_id
      end
    end
    context 'check invalid conditions' do
      it 'fails with an incomplete question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 'renders new again' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end

    context 'PrivatePub' do
      it 'publishes a new question' do
        expect(PrivatePub).to receive(:publish_to).with('/questions', anything)
        post :create, question: attributes_for(:question)
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(question.user) }
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end
      let(:question_attributes) { { title: 'new title', body: 'new body' } }
      before { patch :update, id: question, question: question_attributes, format: :js }
      it 'changes attributes for the question' do
        question.reload
        expect(question).to have_attributes(question_attributes)
      end
      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      it 'does not change the question' do
        patch :update, id: question, question: attributes_for(:invalid_question), format: :js
        expect(question).to have_attributes(attributes_for(:question))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'check for one question' do
      before { sign_in(question.user) }
      it 'removes a question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end
      it 'renders destroy template' do
        delete :destroy, id: question
        expect(response).to redirect_to root_path
      end
    end
    context 'remove a question by another user' do
      let!(:question) { create(:question) }
      it 'cannot remove a question from another user' do
        sign_in(user)
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end
    end
  end

  describe 'CONCERN actions' do
    subject { create(:question) }
    it_behaves_like 'voted'
  end
end
