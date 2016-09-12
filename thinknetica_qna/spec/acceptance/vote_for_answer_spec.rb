require_relative 'acceptance_helper'

feature 'Vote for answer', %q{
  In order to (dis)like the answer
  As an authenticated user
  I want to be able to vote for answers
} do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  scenario 'Authenticated user votes for an answer', js: true do
    sign_in(user)
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_selector(:link_or_button, 'Reject Vote')
      click_on 'Vote+'
      within ".vote-rating-answer-#{answer.id}" do
        expect(page).to have_content '+1'
      end
      expect(page).to_not have_selector(:link_or_button, 'Vote+')
      expect(page).to_not have_selector(:link_or_button, 'Vote-')
      expect(page).to have_selector(:link_or_button, 'Reject Vote')
    end
  end

  scenario 'Non-authenticated user cannot vote', js: true  do
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_selector(:link_or_button, 'Vote+')
      expect(page).to_not have_selector(:link_or_button, 'Vote-')
      expect(page).to_not have_selector(:link_or_button, 'Reject Vote')
    end
  end

  scenario 'Author of the question cannot vote for his question', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_selector(:link_or_button, 'Vote+')
      expect(page).to_not have_selector(:link_or_button, 'Vote-')
      expect(page).to_not have_selector(:link_or_button, 'Reject Vote')
    end
  end

  scenario 'Authenticated user cancels previous vote and re-votes for another question', js: true do
    sign_in(user)
    visit question_path(answer.question)

    within '.answers' do
      click_on 'Vote+'
      click_on 'Reject Vote'
      click_on 'Vote-'
      within ".vote-rating-answer-#{answer.id}" do
        expect(page).to have_content '-1'
      end
    end
  end
end
