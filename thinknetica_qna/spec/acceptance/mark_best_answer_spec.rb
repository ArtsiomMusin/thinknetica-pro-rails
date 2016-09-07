require_relative 'acceptance_helper'

feature 'Mark best answer', %q{
  In order to highlight an answer
  As an authenticated user
  I want to be able to select the best answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  before { create_list(:answer, 3, question: question, user: question.user) }
  scenario 'Author marks one answer as best', js: true do
    sign_in(question.user)
    visit question_path(question)
    within '.answers' do
      click_on 'Mark as Best', match: :first
      expect(page).to have_selector('.glyphicon-thumbs-up', count: 1)
      expect(page).to have_link('Mark as Best', count: 2)
    end
  end

  #scenario 'Author changes the best answer to another one'
  scenario 'Author can mark only one answer as best', js: true do
    sign_in(question.user)
    visit question_path(question)
    within '.answer-1' do
      click_on 'Mark as Best'
    end
    expect(page).to have_selector('.answer-1.glyphicon.glyphicon-thumbs-up')
    within '.answer-2' do
      click_on 'Mark as Best'
    end
    expect(page).to have_selector('.answer-2.glyphicon.glyphicon-thumbs-up')
    expect(page).to have_link('Mark as Best', count: 2)
    expect(page).to have_selector('.glyphicon-thumbs-up', count: 1)
  end

  scenario 'The best answer is always on the top', js: true do
    sign_in(question.user)
    visit question_path(question)
    within '.answer-1' do
      click_on 'Mark as Best'
    end
    sleep(5) # it seems the page hasn't been updated yet when next expect is checked
    # this is a bug in webkit
    # https://github.com/thoughtbot/capybara-webkit/issues/319
    # adding a workaround, but this is not working only on annoying travis
    RSpec.configure do |config|
      Capybara.automatic_reload = false
    end
    expect(all('div', text: /answer/)[1][:class]).to have_content 'glyphicon-thumbs-up'

    within '.answer-2' do
      click_on 'Mark as Best'
    end
    expect(all('div', text: /answer/)[1][:class]).to have_content 'glyphicon-thumbs-up'
    # disabling the workaround
    RSpec.configure do |config|
      Capybara.automatic_reload = true
    end
  end

  scenario 'Authenticated user cannot mark an answer as best if it\'s not his question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'Mark as Best'
  end

  scenario 'Non-authenticated user cannot mark an answer as best' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as Best'
  end
end
