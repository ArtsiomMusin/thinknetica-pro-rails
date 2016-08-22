require 'rails_helper'

feature 'Show question', %q{
  In order to see questions from other users
  As an authenticated user
  I want to be able to see one or all questions
} do
  given(:user) { create(:user) }
  before :each do
    @questions = create_list(:question, 5)
    @questions.each do |question|
      create_list(:answer, 3, question: question)
    end
  end
  scenario 'Authenticated user sees all questions' do
    sign_in(user)
    check_question_count
  end
  scenario 'Non-authenticated user sees all questions' do
    check_question_count
  end
  scenario 'Authenticated user sees a question and all answers' do
    sign_in(user)
    open_and_check_question_with_answers
  end
  scenario 'Non-authenticated user sees a question and all answers' do
    open_and_check_question_with_answers
  end
end
