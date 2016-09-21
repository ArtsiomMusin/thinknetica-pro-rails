require_relative 'acceptance_helper'

feature 'User sign in', %q{
  In order to ask questions
  As a user
  I want to be able to sign in
} do
  given(:user) { create(:user) }

  describe 'standard sign in' do
    scenario 'Registered user tries to sign in' do
      sign_in(user)

      expect(page).to have_content 'Signed in successfully.'
      expect(current_path).to eq root_path
    end

    scenario 'Non-registered user tries to sign in' do
      visit new_user_session_path
      fill_in 'Email', with: 'wrong@test.com'
      fill_in 'Password', with: 'secret_password'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
      expect(current_path).to eq new_user_session_path
    end

    scenario 'Authenticated user tries to log out' do
      sign_in(user)
      click_on 'Log out'

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq root_path
    end

    scenario 'User tries to sign up' do
      clear_emails
      visit new_user_session_path
      click_on 'Sign up'

      email = 'new_user@test.com'
      password = '123456'
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password
      click_on 'Sign up'

      open_email(email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
      expect(current_path).to eq root_path
    end
  end

  describe 'facebook sign in' do
    before(:each) { OmniAuth.config.mock_auth[:facebook] = nil }
    scenario 'Registered user tries to sign in' do
      user = create(:user)
      visit new_user_session_path
      OmniAuth.config.add_mock(:facebook, {info: { email: user.email }})
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(current_path).to eq root_path
    end

    scenario 'Non-registered user tries to sign in' do
      visit new_user_session_path
      email = 'new@user.com'
      OmniAuth.config.add_mock(:facebook, {info: { email: email }})
      click_on 'Sign in with Facebook'

      open_email(email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(current_path).to eq root_path
    end

    scenario 'Authenticated user tries to log out' do
      user = create(:user)
      visit new_user_session_path
      OmniAuth.config.add_mock(:facebook, {info: { email: user.email }})
      click_on 'Sign in with Facebook'
      click_on 'Log out'

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq root_path
    end
  end

  describe 'twitter sign in' do
    before(:each) { OmniAuth.config.mock_auth[:twitter] = nil }
    scenario 'Registered user tries to sign in' do
      user = create(:user)
      visit new_user_session_path
      OmniAuth.config.add_mock(:twitter)
      click_on 'Sign in with Twitter'

      open_email(user.email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end

    scenario 'Non-registered user tries to sign in' do
      visit new_user_session_path
      OmniAuth.config.add_mock(:twitter)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end

    scenario 'Authenticated user tries to log out' do
      user = create(:user)
      OmniAuth.config.add_mock(:twitter)
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      click_on 'Log out'

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq root_path
    end
  end
end
