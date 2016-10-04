require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:comment) { create(:comment) }
  describe 'POST #create for question' do
    let(:object) { create(:question) }
    let(:id) { 'question_id' }
    let(:publish_object_id) { object.id }
    it_behaves_like 'commentable controller'
  end

  describe 'POST #create for answer' do
    let(:object) { create(:answer) }
    let(:id) { 'answer_id' }
    let(:publish_object_id) { object.question.id }
    it_behaves_like 'commentable controller'
  end
end
