require 'rails_helper'

feature 'Delete answer ' do
  given(:user) { create(:user) }
  given(:user2) { create(:user_2) }
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 2) }
  
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