require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate the question
  As an authenticated user
  I want to be able to attach files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:attachment) { create(:attachment, attachable: question) }
  scenario 'Authenticated user adds an attachment when asks a question', js: true do
    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Question text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'Authenticated user adds a couple of attachments when asks a question', js: true do
    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Question text'
    click_link 'Add Attachment'
    inputs = page.all('input[type=file]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

  scenario 'Another user can see attachments of another user', js: true do
    question.attachments << attachment
    sign_in(question.user)
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'Author deletes an attachment'
  scenario 'Another user cannot delete an attachment belongs to another user'
end
