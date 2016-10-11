require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    let(:question) { create(:question, body: 'some body to find') }
    let(:answer) { create(:answer, body: 'some body to find') }
    let(:comment) { create(:comment, body: 'some body to find') }
    let(:user) { create(:user, email: 'some@mail.ru') }
    it 'finds all questions' do
      expect(Question).to receive(:search).with('some body to find')
      xhr :get, :show, text: 'some body to find', questions: true, format: :js
    end
    it 'finds all answers' do
      expect(Answer).to receive(:search).with('some body to find')
      xhr :get, :show, text: 'some body to find', answers: true, format: :js
    end
    it 'finds all comments' do
      expect(Comment).to receive(:search).with('some body to find')
      xhr :get, :show, text: 'some body to find', comments: true, format: :js
    end
    it 'finds all users' do
      expect(User).to receive(:search).with('some\\@mail.ru')
      xhr :get, :show, text: 'some@mail.ru', users: true, format: :js
    end
    it 'finds everything' do
      expect(ThinkingSphinx).to receive(:search).with('some')
      xhr :get, :show, text: 'some', format: :js
    end
  end
end
