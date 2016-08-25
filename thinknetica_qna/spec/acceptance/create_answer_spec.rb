require 'rails_helper'

feature 'Create answer', %q{
  In order to answer questions from other users
  As an authenticated user
  I want to be able to create answers
} do
  given(:question) { create(:question) }

  scenario 'Authenticated user answers a question' do
    sign_in(question.user)
    visit question_path(question)
    fill_in 'Body', with: 'Answer Body'
    click_on 'Add answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer created successfully.'
    expect(page).to have 'Answer Body'
  end

  scenario 'Non-authenticated user cannot answer a question' do
    visit new_question_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user answers a question with an empty answer' do
    sign_in(question.user)
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Add answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Could not create an answer.'
  end
end
