require_relative 'acceptance_helper'

feature 'Mark best answer', %q{
  In order to highlight an answer
  As an authenticated user
  I want to be able to select the best answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  before { create_list(:answer, 3, question: question, user: question.user) }
  scenario 'Author marks one answer as best', js: true do
    sign_in(question.user)
    visit question_path(question)
    within '.answers' do
      click_on 'Mark as Best', match: :first
      expect(page).to have_selector('.glyphicon-thumbs-up', count: 1)
      expect(page).to have_link('Mark as Best', count: 2)
    end
  end

  scenario 'Author can mark only one answer as best'

  scenario 'Author changes the best answer to another one'

  scenario 'The best answer is always on the top'

  scenario 'Authenticated user cannot mark an answer as best if it\'s not his question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'Mark as Best'
  end

  scenario 'Non-authenticated user cannot mark an answer as best' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as Best'
  end
end
