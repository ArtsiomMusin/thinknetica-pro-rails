require_relative 'acceptance_helper'

feature 'Comment on answer', %q{
  In order to add comments to the answer
  As an authenticated user
  I want to be able to leave comments for answers
} do
  given(:answer) { create(:answer) }
  scenario 'Authenticated user comments on an answer' do
    sign_in(answer.user)
    visit question_path(answer.question)
    within '.answer-comments' do
      click_on 'Add comment'
      fill_in 'Comment text', with: 'Some Comment'
      click_on 'Save'
      expect(page).to have_content 'Some Comment'
    end
  end

  scenario 'Non-authenticated user cannot comment on an answer' do
    visit question_path(answer.question)
    within '.answer-comments' do
      expect(page).to_not have_content 'Add comment'
    end
  end

  scenario 'Authenticated user adds an empty comment' do
    sign_in(answer.user)
    visit question_path(answer.question)
    within '.answer-comments' do
      click_on 'Add comment'
      click_on 'Save'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end
end
