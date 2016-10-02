require 'rails_helper'

describe 'Answer API' do
  describe 'GET /index' do
    let(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question) }
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'has answers included in the question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains the #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end
  describe 'GET /show' do
    let(:answer) { create(:answer) }

    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains the #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context 'comments' do
        it 'included in the answer' do
          expect(response.body).to have_json_path('comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains the #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in the answer' do
          expect(response.body).to have_json_path('attachments')
        end

        it 'includes the url' do
          expect(response.body).to include_json((Rails.application.config.hostname_url + attachment.file.url).to_json).at_path('attachments/0/url')
        end

        %w(id created_at updated_at).each do |attr|
          it "contains the #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    let(:question) { create(:question) }
    let(:answer) { create(:question, question: question) }

    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json, question_id: question.id, answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if no access_token' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '123456', question_id: question.id, answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'creates a new answer with parameters' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token, question_id: question.id, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      before { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token, question_id: question.id, answer: attributes_for(:answer) } }
      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'has the right user assigned' do
        new_answer = Answer.last
        expect(new_answer.user.id).to eq access_token.resource_owner_id
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains the #{attr}" do
          new_answer = Answer.last
          expect(response.body).to be_json_eql(new_answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end
    end
  end
end