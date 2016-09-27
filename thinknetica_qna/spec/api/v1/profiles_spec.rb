require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if no access_token' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }
      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(email id created_at updated_at admin).each do |attr|
        it "contains the #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain the #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get '/api/v1/profiles', params: { format: :json }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if no access_token' do
        get '/api/v1/profiles', params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 2) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }
      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'does not contain the current user' do
        expect(response.body).to_not include_json(me.to_json)
      end

      it 'contains all other users' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      %w(email id created_at updated_at admin).each do |attr|
        it "contains the #{attr}" do
          user = users.first
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain the #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end

    end
  end
end
