require 'rails_helper'

feature 'Create question', %q{
  In order to answer questions from other users
  As an authenticated user
  I want to be able to create answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user answers a question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Add answer'
    expect(current_path).to eq new_question_answer_path(question)

    fill_in 'Body', with: 'Answer Body'
    click_on 'Create'
    expect(page).to have_content 'Your answer created successfully.'
  end
  scenario 'Non-authenticated user cannot answer a question' do
    visit question_path(question)
    expect(page).to_not have_content 'Add question'
  end
end
