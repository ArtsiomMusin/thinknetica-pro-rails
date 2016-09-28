require 'rails_helper'

describe 'Answer API' do
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
          expect(response.body).to include_json(attachment.file.url.to_json).at_path('attachments/0/url')
        end

        %w(id created_at updated_at).each do |attr|
          it "contains the #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end
      end
    end
  end
end
