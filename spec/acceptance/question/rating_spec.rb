require 'rails_helper'

feature 'Vote for question' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    scenario 'Author of question try vote for question' do
      sign_in(author)
      visit question_path(question)

      within '.rating_question' do
        expect(page).to_not have_link 'Vote for'
        expect(page).to_not have_link 'Vote against'
      end
    end

    scenario 'Author of question can see rating' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content 'Rating question: 0'
    end


    scenario 'No author try to vote', js: true do
      sign_in(user)
      visit question_path(question)

      within '.rating_question' do
        click_on 'Vote for'
      end

      expect(page).to have_content 'Rating question: 1'
    end

    scenario 'No author try to reset data', js: true do
      sign_in(user)
      visit question_path(question)

      within '.rating_question' do
        click_on 'Vote for'
        click_on 'back vote'
      end

      expect(page).to have_content 'Rating question: 0'
    end
  end

  describe 'No authenticated user' do
    scenario 'can see rating' do
      visit question_path(question)

      expect(page).to have_content 'Rating question: 0'
    end

    scenario 'try vote for question' do
      visit question_path(question)

      expect(page).to_not have_link 'Vote for'
      expect(page).to_not have_link 'Vote against'
    end
  end
end