require_relative 'acceptance_helper'

feature 'Vote for answer', %q{
  In order to (dis)like the answer
  As an authenticated user
  I want to be able to vote for answers
} do
  scenario 'Authenticated user votes for an answer'
  scenario 'Author of the answer cannot vote for his answer'
  scenario 'Authenticated user adds a positive or negative vote'
  scenario 'Authenticated user cannot vote the second time'
  scenario 'Authenticated user cancels previous vote and re-votes for another answer'
  scenario 'Answer has the voting statistics'
end
