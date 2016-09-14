require_relative 'acceptance_helper'

feature 'Comment on question', %q{
  In order to add comments to the question
  As an authenticated user
  I want to be able to leave comments for questions
} do
  given(:question) { create(:question) }
  scenario 'Authenticated user comments on a question' do
    sign_in(question.user)
    visit question_path(question)
    within '.question-comments' do
      click_on 'Add comment'
      fill_in 'Comment text', with: 'Some Comment'
      click_on 'Save'
      expect(page).to have_content 'Some Comment'
    end
  end

  scenario 'Non-authenticated user cannot comment on a question' do
    visit question_path(question)
    within '.question-comments' do
      expect(page).to_not have_content 'Add comment'
    end
  end

  scenario 'Authenticated user adds an empty comment' do
    sign_in(question.user)
    visit question_path(question)
    within '.question-comments' do
      click_on 'Add comment'
      click_on 'Save'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end
end
