require 'rails_helper'

feature 'Add comment to question' do 
  given(:user){ create(:user) }
  given(:question){ create(:question) }
  given(:answer){ create(:answer, question: question)}

  scenario 'user try create comment for answer', js: true do
    answer
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end
    Capybara.using_session('guest') do
      visit question_path(question)
    end
    Capybara.using_session('user') do
      within '.answer_comment_form' do
        click_on 'create comment'
        fill_in 'Write your comments', with: 'my answer comment'
        click_on 'Create'
      end
      sleep(2)
      save_and_open_page
      expect(page).to have_content 'my answer comment'
    end
    Capybara.using_session('guest') do
      sleep(2)
      expect(page).to have_content 'my answer comment'
    end
  end

  scenario 'no login user try create comment' do
    visit question_path(question)
    expect(page).to_not have_content 'create comment'
  end
end