require 'rails_helper'

feature 'Subscribe / Unsubscribe' do
  given(:question) { create(:question) }

  context 'Authorized user' do
    given(:user){ create(:user) }
    given(:subscribe) { create(:subscribe, user: user, question: question)}

    scenario 'try subscribe to question' do
      sign_in user
      visit question_path(question)
      click_on 'Subscribe'

      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'try unsubscribe to question' do
      subscribe
      sign_in user
      visit question_path(question)
      click_on 'Unsubscribe'
      expect(page).to have_content 'Subscribe'
    end
  end

  context 'Unauthorized user' do
    scenario 'try subscribe to question' do
      visit question_path(question)
      expect(page).to_not have_content 'Subscribe'
    end

    scenario 'try unsubscribe to question' do
      visit question_path(question)
      expect(page).to_not have_content 'Unsubscribe'
    end
  end
end
