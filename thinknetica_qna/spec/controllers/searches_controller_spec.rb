require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    context 'questions' do
      let(:questions) { create_list(:question, 2, body: 'some body to find') }
      it 'finds all questions' do
        expect(Question).to receive(:search).with('some body to find')
        get :show, text: 'some body to find', questions: true, format: :js
      end
      # it 'renders index' do
      #   expect(response).to render_template :index
      # end
    end

  end
end
