require_relative 'acceptance_helper'

feature 'Edit answer', %q{
  In order to change or update
  As an authenticated user
  I want to be able to edit answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  before { create(:answer, question: question, user: question.user) }

  scenario 'Non-authenticated user tries to edit an answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Authenticated user tries to edit an answer' do
    sign_in(question.user)
    visit question_path(question)

    within '.answers' do
      expect(page).to have_link 'Edit'
    end
  end

  scenario 'Authenticated user can edit his answer', js: true do
    sign_in(question.user)
    visit question_path(question)

    click_on 'Edit'
    within '.answers' do
      fill_in 'Answer', with: 'edited answer'
      click_on 'Save'

      expect(page).to_not have_content question.answers.first.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'Authenticated user cannot edit an answer belogns to another user' do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
