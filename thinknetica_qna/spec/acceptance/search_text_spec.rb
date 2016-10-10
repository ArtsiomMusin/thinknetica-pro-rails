require_relative 'acceptance_helper'

feature 'Search for info', %q{
  In order to find information quickly
  As any user
  I want to be able to seacrh on key words or phrases
} do
  given(:question) { create(:question, title: 'Find me question') }
  given(:answer) { create(:answer, title: 'Find me answer') }
  given(:comment) { create(:comment, body: 'Find me comment') }
  given(:user) { create(:user, email: 'FindMe@tutu.com') }

  scenario 'User finds a question by some text' do
    visit search_path

    check 'questions'
    fill_in 'Search text', with: 'Find me question'
    click_on 'Search'

    expect(page).to have_content 'Find me question'
  end

  scenario 'User finds an answer by some text' do
    visit search_path

    check 'answers'
    fill_in 'Search text', with: 'Find me answer'
    click_on 'Search'

    expect(page).to have_content 'Find me answer'
  end

  scenario 'User finds a comment by some text' do
    visit search_path

    check 'comments'
    fill_in 'Search text', with: 'Find me comment'
    click_on 'Search'

    expect(page).to have_content 'Find me comment'
  end

  scenario 'User finds a user by some text' do
    visit search_path

    check 'users'
    fill_in 'Search text', with: 'FindMe@tutu.com'
    click_on 'Search'

    expect(page).to have_content 'FindMe@tutu.com'
  end
  scenario 'Authenticated user finds a question by some text' do
    sign_in(user)
    visit search_path

    check 'questions'
    fill_in 'Search text', with: 'Find me question'
    click_on 'Search'

    expect(page).to have_content 'Find me question'
  end
  scenario 'User finds everything by some text' do
    visit search_path

    fill_in 'Search text', with: 'Find'
    click_on 'Search'

    expect(page).to have_content 'Find me question'
    expect(page).to have_content 'Find me answer'
    expect(page).to have_content 'Find me comment'
    expect(page).to have_content 'FindMe@tutu.com'
  end
end
