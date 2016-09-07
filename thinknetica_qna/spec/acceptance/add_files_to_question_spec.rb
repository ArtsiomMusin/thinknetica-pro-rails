require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate the question
  As an authenticated user
  I want to be able to attach files
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user adds an attachment when asks a question' do
    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Question text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'Authenticated user adds a couple of attachments when asks a question' do
    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Question text'

    within '.nested-fields' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb", id: 'question_attachments_attributes_0_file'
    end
    click_on 'Add Attachment'
    within '.nested-fields' do
      save_and_open_page
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb", id: 'question_attachments_attributes_1_file'
    end
    save_and_open_page
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end
