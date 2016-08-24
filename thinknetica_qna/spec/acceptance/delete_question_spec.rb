require 'rails_helper'

feature 'Delete question', %q{
  In order to remove questions
  As an authenticated user
  I want to be able to delete questions
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  before { create_list(:answer, 3, question: question) }
  scenario 'Authenticated user deletes a question belongs to this user' do
    sign_in(question.user)
    visit question_path(question)
    click_on 'Remove question'

    expect(page).to have_content 'Question removed successfully.'
  end
  scenario 'Non-authenticated user cannot delete a question' do
    visit question_path(question)
    expect(page).to_not have_content 'Remove question'
  end
  scenario 'Authenticated user cannot delete a question belongs to another user' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content 'Remove question'
  end
end