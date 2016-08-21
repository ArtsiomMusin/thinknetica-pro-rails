require 'rails_helper'

feature 'Create question', %q{
  In order to answer questions from other users
  As an authenticated user
  I want to be able to create answers
} do
  scenario 'Authenticated user answers a question'
  scenario 'Non-authenticated user cannot answer a question'
end
