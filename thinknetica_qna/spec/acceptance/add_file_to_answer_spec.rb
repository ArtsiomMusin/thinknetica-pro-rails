require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate the answer
  As an authenticated user
  I want to be able to attach files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user adds when adds an answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Title', with: 'Test Title'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add answer'
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
