require 'rails_helper'

feature 'Add comment to question' do 
  given(:user){ create(:user) }
  given(:question){ create(:question) }

  scenario 'user try create comment for question', js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end
    Capybara.using_session('guest') do
      visit question_path(question)
    end
    Capybara.using_session('user') do
      within '.question_comment_form' do
        click_on 'create comment'
        fill_in 'Write your comments', with: 'my question comment'
        click_on 'Create'
      end
      sleep(2)
      expect(page).to have_content 'my question comment'
    end
    Capybara.using_session('guest') do
      sleep(2)
      expect(page).to have_content 'my question comment'
    end
  end

  scenario 'no login user try create comment' do
    visit question_path(question)
    expect(page).to_not have_content 'create comment'
  end
end