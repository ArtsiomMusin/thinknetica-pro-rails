require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate the answer
  As an authenticated user
  I want to be able to attach files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question)}
  given(:attachment) { create(:attachment, attachable: answer) }
  scenario 'Authenticated user adds when adds an answer', js: true do
    sign_in(question.user)

    visit question_path(question)
    fill_in 'Body', with: 'Body Title'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add answer'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'Authenticated user adds a couple of attachments when adds an answer', js: true do
    sign_in(question.user)

    visit question_path(question)
    fill_in 'Body', with: 'Body text'
    click_link 'Add Attachment'
    inputs = page.all('input[type=file]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Add answer'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

  scenario 'Another user can see attachments of another user', js: true do
    answer.attachments << attachment
    sign_in(question.user)
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'Author deletes an attachment', js: true do
    answer.attachments << attachment
    sign_in(answer.user)
    visit question_path(question)
    within '.answers' do
      click_on 'Remove Attachment'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario 'Another user cannot delete an attachment belongs to another user', js: true do
    answer.attachments << attachment
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Remove Attachment'
    end
  end
end
