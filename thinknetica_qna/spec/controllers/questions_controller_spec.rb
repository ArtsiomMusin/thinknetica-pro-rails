require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before do
      get :index
    end
    it 'gets all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index' do
      expect(response).to render_template :index
    end
  end
  describe 'GET #show' do
    let(:question) { create(:question) }
    before do
      get :show, id: question
    end
    it 'shows one specific question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders index' do
      expect(response).to render_template :show
    end
  end
end
