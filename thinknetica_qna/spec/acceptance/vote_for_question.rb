require_relative 'acceptance_helper'

feature 'Vote for question', %q{
  In order to (dis)like the question
  As an authenticated user
  I want to be able to vote for questions
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  scenario 'Authenticated user votes for a question' do
    sign_in(user)
    visit questions_path

    click_on 'Vote+'
    within '.votes-rating' do
      expect(page).to have_content '+1'
    end
    expect(page).to_not have_content 'Vote+'
    expect(page).to_not have_content 'Vote-'
  end

  scenario 'Non-authenticated user cannot vote' do
    visit questions_path

    expect(page).to_not have_content 'Vote+'
    expect(page).to_not have_content 'Vote-'
    expect(page).to_not have_content 'Reject Vote'
  end

  scenario 'Author of the question cannot vote for his question' do
    sign_in(question.user)
    visit questions_path

    expect(page).to_not have_content 'Vote+'
    expect(page).to_not have_content 'Vote-'
    expect(page).to_not have_content 'Reject Vote'
  end

  scenario 'Authenticated user cancels previous vote and re-votes for another question' do
    sign_in(user)
    visit questions_path

    click_on 'Vote+'
    click_on 'Reject Vote'
    click_on 'Vote-'
    within '.votes-rating' do
      expect(page).to have_content '-1'
    end
  end
end
