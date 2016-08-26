require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove answers
  As an authenticated user
  I want to be able to delete answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  before { create(:answer, question: question, user: question.user) }
  scenario 'Authenticated user deletes an answer belongs to this user' do
    sign_in(question.user)
    visit question_path(question)
    click_on 'Remove answer', match: :first

    expect(page).to have_content 'Answer removed successfully.'
    expect(page).to_not have_content 'AnswerText'
  end
  scenario 'Non-authenticated user cannot delete an answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Remove answer'
  end
  scenario 'Authenticated user cannot delete an answer belongs to another user' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content 'Remove answer'
  end
end
