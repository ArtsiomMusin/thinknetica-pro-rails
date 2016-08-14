require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  describe 'GET #index' do
    let(:answers) { create_list(:answer, 2) }
    before { get :index }
    it 'gets all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end
    it 'renders index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: answer }
    it 'shows one specific answer' do
      expect(assigns(:answer)).to eq answer
    end
    it 'renders index' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }
    it 'creates a new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'valid tests' do
      let(:question) { create(:question) }
      it 'creates a new answer with parameters' do
        expect { post :create, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end
      it 'renders show after creating a new answer' do
        post :create, answer: attributes_for(:answer)
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end
    context 'invalid tests' do
      it 'fails with an incomplete answer' do
        expect { post :create, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 'renders new again' do
        post :create, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

end
