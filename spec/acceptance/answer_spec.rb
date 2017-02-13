require 'rails_helper'

feature 'Answer for question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user_2) }
  given(:answers) { create_list(:answer, 2) }
  given(:question) { create(:question) }

  scenario 'Authenticated user try to create valid answer for question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Write your answer', with: 'my answer'
    click_on 'create answer'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'my answer'
    expect(current_path).to eq question_path(question)
  end

   scenario 'Authenticated user try to create invalid answer for question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Write your answer', with: ''
    click_on 'create answer'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'no authenticated user try to create answer for question' do
    visit question_path(question)
    fill_in 'Write your answer', with: 'my answer'
    click_on 'create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Author of answer try delete answer' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Write your answer', with: 'My comment'
    click_on 'create answer'
    click_on 'Delete answer'
    expect(page).to have_content 'Your answer was success deleted'
    expect(page).to_not have_content 'My comment'
    expect(current_path).to eq question_path(question)
  end
  
  scenario 'No Author of answer try delete answer' do
    sign_in(user2)
    answers
    visit question_path(question)
    
    expect(page).to_not have_content 'Delete answer'
  end
end