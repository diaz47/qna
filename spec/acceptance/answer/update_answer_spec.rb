require 'rails_helper'

feature 'Update answer' do
  given(:question) { create(:question)}
  given(:user) { create(:user)}
  given(:user_2) { create(:user_2)}
  given!(:answer) { create(:answer, question: question, user: user)}

  describe 'Author of answer ' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'Try update with valid data', js: true do
      within '.answer_list' do
        click_on 'Edit answer'
        fill_in 'New answer', with: 'my new answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'my new answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Try update with invalid data', js: true do
      within '.answer_list' do
        click_on 'Edit answer'
        fill_in 'New answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'No Author of answer try to update answer', js: true do
    sign_in(user_2)
    visit question_path(question)
    within '.answer_list' do
      answer
      expect(page).to_not have_link 'Edit answer'
    end
  end

  scenario 'No authenticated user try to update answer', js: true do
    visit question_path(question)
    within '.answer_list' do
      answer
      expect(page).to_not have_link 'Edit answer'
    end
  end
end