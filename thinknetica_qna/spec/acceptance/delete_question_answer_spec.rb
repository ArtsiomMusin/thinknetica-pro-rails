require 'rails_helper'

feature 'Delete question or answer', %q{
  In order to remove questions or answers
  As an authenticated user
  I want to be able to delete questions or answers
} do
  scenario 'Authenticated user deletes a question belongs to this user'
  scenario 'Non-authenticated user cannot delete a question'
  scenario 'Authenticated user deletes a answer belongs to this user'
  scenario 'Non-authenticated user cannot delete a answer'
  scenario 'Authenticated user deletes a question belongs to another user'
  scenario 'Authenticated user deletes a answer belongs to another user'
  scenario 'Authenticated user deletes a question belongs to this user but answers belong to another user'
end
