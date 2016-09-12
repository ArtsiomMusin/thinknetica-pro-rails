require_relative 'acceptance_helper'

feature 'Vote for answer and question', %q{
  In order to (dis)like the answer
  As an authenticated user
  I want to be able to vote for answers
} do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  scenario 'Authenticated user votes for an answer', js: true do
    sign_in(user)
    visit question_path(answer.question)

    within '.question' do
      click_on 'Vote+'
    end
    sleep(5)
    within '.answers' do
      click_on 'Vote+'
      within ".vote-rating-answer-#{answer.id}" do
        expect(page).to have_content '+1'
      end
    end
  end
end
