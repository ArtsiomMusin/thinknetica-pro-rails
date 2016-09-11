require_relative 'acceptance_helper'

feature 'Vote for question', %q{
  In order to (dis)like the question
  As an authenticated user
  I want to be able to vote for questions
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  scenario 'Authenticated user votes for a question', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Reject Vote')
    click_on 'Vote+'
    within '.vote-rating' do
      expect(page).to have_content '+1'
    end
    expect(page).to_not have_selector(:link_or_button, 'Vote+')
    expect(page).to_not have_selector(:link_or_button, 'Vote-')
    expect(page).to have_selector(:link_or_button, 'Reject Vote')
  end

  scenario 'Non-authenticated user cannot vote', js: true  do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Vote+')
    expect(page).to_not have_selector(:link_or_button, 'Vote-')
    expect(page).to_not have_selector(:link_or_button, 'Reject Vote')
  end

  scenario 'Author of the question cannot vote for his question', js: true do
    sign_in(question.user)
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Vote+')
    expect(page).to_not have_selector(:link_or_button, 'Vote-')
    expect(page).to_not have_selector(:link_or_button, 'Reject Vote')
  end

  scenario 'Authenticated user cancels previous vote and re-votes for another question', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Vote+'
    click_on 'Reject Vote'
    click_on 'Vote-'
    within '.vote-rating' do
      expect(page).to have_content '-1'
    end
  end
end
