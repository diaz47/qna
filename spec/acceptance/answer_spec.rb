require 'rails_helper'

feature 'Answer for question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user_2) }
  given(:question) { create(:question) }

  scenario 'Authenticated user try to create answer for question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Write your answer', with: 'my answer'
    click_on 'create answer'

    expect(page).to have_content 'Your answer successfully created'
    expect(current_path).to eq question_path(question)
  end

  scenario 'no authenticated user try to create answer for question' do
    visit question_path(question)
    fill_in 'Write your answer', with: 'my answer'
    click_on 'create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Author of answer try delete question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Write your answer', with: 'My comment'
    click_on 'create answer'
    click_on 'Delete answer'
    expect(page).to have_content 'Your answer was success deleted'
    expect(current_path).to eq question_path(question)
  end
  
  scenario 'No Author of answer try delete question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Write your answer', with: 'My comment'
    click_on 'create answer'
    click_on 'Log out'
    sign_in(user2)
    visit question_path(question)
    click_on 'Delete answer'
    
    expect(page).to have_content 'You cannot delete this question'
    expect(current_path).to eq question_path(question)
  end
end