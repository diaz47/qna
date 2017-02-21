require 'rails_helper'

feature 'Update question' do 
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user)}
  given(:question_2){ create(:question)}
  
  describe 'Author try update' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'try update with valid data', js: true do
      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: "my new title"
        fill_in 'Body', with: "my new body"
        click_on 'Update Question'

        expect(page).to_not have_content question.body
        expect(page).to_not have_content question.title
        expect(page).to have_content 'my new title'
        expect(page).to have_content 'my new body'
        expect(page).to_not have_selector 'text_field'
        expect(page).to_not have_selector 'text_area'
      end
    end
    scenario 'try update with invalid data', js: true do
      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: ""
        fill_in 'Body', with: "my new body"
        click_on 'Update Question'

        expect(page).to have_content question.body
        expect(page).to have_content question.title
        expect(page).to_not have_content 'my new body'
        expect(page).to have_content "Title can't be blank"
      end
    end
  end

  describe 'No Author try update' do
    scenario 'No Author try update question' do
      sign_in(user)
      visit question_path(question_2)
      expect(page).to_not have_link 'Edit question'
    end
  end

  describe 'No Authenticated user try update' do
    scenario 'No Author try update question' do
      visit question_path(question_2)
      expect(page).to_not have_link 'Edit question'
    end
  end

end