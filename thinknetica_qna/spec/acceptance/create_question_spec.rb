require 'rails_helper'

feature 'Create question', %q{
  In order to recieve answers from other users
  As an authenticated user
  I want to be able to create questions
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Question text'
    click_on 'Create'

    expect(page).to have_content 'Your question created successfully.'
  end

  scenario 'Non-authenticated user cannot create questions' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user creates a question with empty fields' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content 'Could not create a question.'
  end
end
