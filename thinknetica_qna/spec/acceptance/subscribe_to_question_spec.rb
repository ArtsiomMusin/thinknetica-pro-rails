require_relative 'acceptance_helper'

feature 'Subscribe to question', %q{
  In order to be allert on the question changes
  As an authenticated user
  I want to be able to subscribe to questions
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  scenario 'Authenticated user subscribes to the question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Subscribe'

    expect(page).to have_content 'You subscribed to this question!'
  end
  scenario 'Non-authenticated user cannot subscribe to the question' do
    visit question_path(question)
    expect(page).to_not have_link 'Subscribe'
  end
  scenario 'Authenticated user unsubscribes from the question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Subscribe'
    click_on 'Unsubscribe'

    expect(page).to have_content 'You removes your subscription from this question!'
  end

  scenario 'Author of the question unsubscribes from the question' do
    sign_in(question.user)
    visit question_path(question)
    click_on 'Unsubscribe'

    expect(page).to have_content 'You removes your subscription from this question!'
  end

  scenario 'Authenticated user receives an email when a new answer is created' do
    sign_in(user)
    visit question_path(question)
    click_on 'Subscribe'

    fill_in 'Body', with: 'Answer Body'
    click_on 'Add answer'
    expect(page).to have_content 'Your answer created successfully.'

    open_email(user.email)
    expect(current_email.subject).to eq 'Question has a new answer!'
  end
end
