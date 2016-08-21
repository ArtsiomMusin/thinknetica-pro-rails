require 'rails_helper'

feature 'Show question', %q{
  In order to see questions from other users
  As an authenticated user
  I want to be able to see one or all questions
} do
  scenario 'Authenticated user sees all questions'
  scenario 'Non-authenticated user sees all questions'
  scenario 'Authenticated user sees a question and all answers'
  scenario 'Non-authenticated user sees a question and all answers'
end
