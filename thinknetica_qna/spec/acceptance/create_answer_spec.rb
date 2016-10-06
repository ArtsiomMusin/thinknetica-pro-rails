require_relative 'acceptance_helper'

feature 'Create answer', %q{
  In order to answer questions from other users
  As an authenticated user
  I want to be able to create answers
} do
  given(:question) { create(:question) }

  scenario 'Authenticated user answers a question', js: true do
    sign_in(question.user)
    visit question_path(question)
    fill_in 'Body', with: 'Answer Body'
    click_on 'Add answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer created successfully.'
    within '.answers' do
      expect(page).to have_content 'Answer Body'
    end
  end

  scenario 'Non-authenticated user cannot answer a question' do
    visit question_path(question)
    expect(page).to_not have_button 'Add answer'
  end

  scenario 'Authenticated user answers a question with an empty answer', js: true do
    sign_in(question.user)
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Add answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'An email is sent to the question author when an answer is created', js: true do
    sign_in(question.user)
    visit question_path(question)
    fill_in 'Body', with: 'Answer Body'
    click_on 'Add answer'
    expect(page).to have_content 'Your answer created successfully.'

    open_email(question.user.email)
    expect(current_email.subject).to eq 'Got a new answer!'
  end
end
