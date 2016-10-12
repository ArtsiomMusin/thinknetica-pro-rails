require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    let(:question) { create(:question, body: 'some body to find') }
    let(:answer) { create(:answer, body: 'some body to find') }
    let(:comment) { create(:comment, body: 'some body to find') }
    let(:user) { create(:user, email: 'some@mail.ru') }
    it 'finds everything' do
      expect(ThinkingSphinx).to receive(:search).with('some', { classes: [Question, Answer, Comment, User] })
      xhr :get, :show, search: { text: 'some' }, format: :js
    end
  end
end
