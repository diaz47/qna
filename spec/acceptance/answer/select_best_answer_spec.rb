require 'rails_helper'

feature 'Select best answer' do
  given(:user) { create(:user) }
  given(:user_2) { create(:user_2) }
  given(:question){ create(:question, user: user)}
  given!(:answer){ create(:answer, question: question)}

  scenario 'Author of question try to select best question' do
    sign_in(user)
    visit question_path(question)
    answer
    click_on 'Mark as the best'

    expect(page).to have_content 'Best asnwer was selected'
  end

  scenario 'No Author of question try to select best question ' do
    sign_in(user_2)
    visit question_path(question)
    answer

    expect(page).to_not have_link 'Mark as the best'
  end

  scenario 'No Authenticated user of question try to select best question ' do
    visit question_path(question)
    answer

    expect(page).to_not have_link 'Mark as the best'
  end
end