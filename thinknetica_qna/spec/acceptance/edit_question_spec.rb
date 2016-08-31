require_relative 'acceptance_helper'

feature 'Edit question', %q{
  In order to change or update
  As an authenticated user
  I want to be able to edit questions
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Non-authenticated user tries to edit a question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Authenticated user tries to edit a question' do
    sign_in(question.user)
    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'Edit'
    end
  end

  scenario 'Authenticated user can edit his question', js: true do
    sign_in(question.user)
    visit question_path(question)

    click_on 'Edit'
    within '.question' do
      fill_in 'Title', with: 'edited title'
      fill_in 'Body', with: 'edited body'
      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
      expect(page).to_not have_selector 'input'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'Authenticated user cannot edit a question belogns to another user' do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
