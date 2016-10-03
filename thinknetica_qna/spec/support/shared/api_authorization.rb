require 'rails_helper'

shared_examples_for 'API authenticable' do
  context 'unauthorized' do
    it 'returns 401 status if no access_token' do
      do_request
      expect(response.status).to eq 401
    end
    it 'returns 401 status if no access_token' do
      do_request(access_token: '123456')
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'authorized profile API authenticable' do
  it 'returns 200 status' do
    expect(response).to be_success
  end

  %w(password encrypted_password).each do |attr|
    it "does not contain the #{attr}" do
      expect(response.body).to_not have_json_path(attr)
    end
  end
end

shared_examples_for 'post API authenticable' do
  it 'returns 200 status' do
    expect(response).to be_success
  end

  it 'has the right user assigned' do
    new_object = object_klass.last
    expect(new_object.user.id).to eq access_token.resource_owner_id
  end
end

shared_examples_for 'API commentable' do
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
end

shared_examples_for 'API attachable' do
  context 'attachments' do
    it 'included in the question' do
      expect(response.body).to have_json_size(1).at_path('attachments')
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
