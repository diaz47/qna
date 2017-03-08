require 'rails_helper'

feature 'Add answer for question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user try to create valid answer for question', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Write your answer', with: 'my answer'
    click_on 'create answer'

    expect(page).to have_content 'my answer'
    expect(current_path).to eq question_path(question)
  end

   scenario 'Authenticated user try to create invalid answer for question', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Write your answer', with: ''
    click_on 'create answer'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'no authenticated user try to create answer for question' do
    visit question_path(question)


    expect(page).to_not have_content 'Write your answer'
    expect(page).to_not have_content 'create answer'
  end
end