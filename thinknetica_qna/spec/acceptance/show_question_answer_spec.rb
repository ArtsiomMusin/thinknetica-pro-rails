require 'rails_helper'

feature 'Show question and answers', %q{
  In order to see questions and answers from other users
  As an authenticated user
  I want to be able to see one or all questions and child answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  before { create_list(:answer, 3, question: question) }
  scenario 'Authenticated user sees a question' do
    sign_in(user)
    visit questions_path
    expect(page).to have_content 'Question:'
  end
  scenario 'Non-authenticated user sees a question' do
    visit questions_path
    expect(page).to have_content 'Question:'
  end
  scenario 'Authenticated user sees a question and all answers' do
    sign_in(user)
    visit questions_path
    click_on question.title

    expect(current_path).to eq question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content(question.answers.first.body, count: question.answers.count)
  end
  scenario 'Non-authenticated user sees a question and all answers' do
    visit questions_path
    click_on question.title

    expect(current_path).to eq question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content(question.answers.first.body, count: question.answers.count)
  end
end
