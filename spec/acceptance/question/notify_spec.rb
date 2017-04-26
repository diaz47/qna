require 'rails_helper'

feature 'Question notification' do
  given(:author) { create :user }
  given(:user) { create :user }

  scenario 'Author of question have question notifications ',js: true  do
    Sidekiq::Testing.inline! do
      Capybara.using_session('author') do
        sign_in(author)

        visit new_question_path
        fill_in 'Title', with: 'My title'
        fill_in 'Body', with: 'My question'
        click_on 'Create Question'
      end
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(Question.last)
        fill_in 'Write your answer', with: 'my answer'
        click_on 'create answer'
      end
      Capybara.using_session('author') do
        sleep(3)
        open_email(author.email)
        expect(current_email).to have_content('my answer')
      end
    end
  end
end
