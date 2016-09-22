require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #build_by_email' do
    it 'builds a user with email params' do
      session['omniauth.data'] = {
        'provider' => 'facebook', 'uid' => 123456,
        'user_password' => '123456'
      }
      expect { post :build_by_email, user: { email: 'test@mail.com' } }.to change(User, :count).by(1)
    end
  end
end
