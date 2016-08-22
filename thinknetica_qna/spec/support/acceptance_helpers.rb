module AcceptanceHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def open_and_check_question_with_answers
    visit questions_path
    first_question = @questions.first
    click_on first_question.title, match: :first

    expect(current_path).to eq question_path(first_question)
    save_and_open_page
    expect(page).to have_content first_question.title
    expect(page).to have_content first_question.body
    expect(page).to have_content(first_question.answers.first.body, count: first_question.answers.count)
  end

  def check_question_count
    visit questions_path
    expect(page).to have_content('Question:', count: @questions.count)
  end
end
