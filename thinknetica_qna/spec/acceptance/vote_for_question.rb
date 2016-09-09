require_relative 'acceptance_helper'

feature 'Vote for question', %q{
  In order to (dis)like the question
  As an authenticated user
  I want to be able to vote for questions
} do
  scenario 'Authenticated user votes for a question'
  scenario 'Author of the question cannot vote for his question'
  scenario 'Authenticated user adds a positive or negative vote'
  scenario 'Authenticated user cannot vote the second time'
  scenario 'Authenticated user cancels previous vote and re-votes for another question'
  scenario 'Question has the voting statistics'
end
