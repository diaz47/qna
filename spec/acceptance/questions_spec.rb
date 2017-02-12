require 'rails_helper'

feature 'Questions' do
  given(:user) { create(:user) }
  given(:answers) { create_list(:answer, 2) }
  given(:questions) { create_list(:question, 2) }

  scenario 'Authenticated user try to create question' do
    sign_in(user)
    create_question

    expect(page).to have_content 'Your question successfully created'
  end

  scenario 'No Authenticated user try to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'User can see all questions on page' do
    questions
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end

  scenario 'User can see answers for question' do
    answers

    visit question_path(questions[0])
    save_and_open_page
    expect(page).to have_content answers[0].body
  end

  scenario 'Author of question try delete question' do
    sign_in(user)
    create_question
    click_on 'Delete question'

    expect(page).to have_content 'Your question was deleted'
    expect(current_path).to eq questions_path
  end
  

  scenario 'No Author of question try delete question' do
    sign_in(user)
    visit question_path(questions[0])
    click_on 'Delete question'

    expect(page).to have_content 'You cannot delete this question'
    expect(current_path).to eq question_path(questions[0])
  end
end