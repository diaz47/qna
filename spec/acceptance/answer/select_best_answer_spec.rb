require 'rails_helper'

feature 'Select best answer' do
  given(:user) { create(:user) }
  given(:user_2) { create(:user_2) }
  given(:question){ create(:question, user: user)}
  given!(:answer){ create(:answer, question: question)}
  given!(:best_answer){ create(:answer, best_answer: true, question: question)}

  scenario 'Author of question try to select best question' do
    sign_in(user)
    visit question_path(question)
    answer
    click_on 'Mark as the best'

    expect(page).to have_content 'Best asnwer was selected'
    expect(page).to have_content "#{answer.body}(the best answer)"
  end

  scenario 'Best answer should be the first' do
    sign_in(user)
    visit question_path(question)
    answer
    best_answer

    within page.all('ul li').first do
      expect(page).to have_content "#{best_answer.body}(the best answer)"
    end
  end

  scenario 'Author of question try to select other best question' do
    sign_in(user)
    visit question_path(question)
    best_answer
    answer
    click_on 'Mark as the best'

    expect(page).to have_content 'Best asnwer was selected'
    expect(page).to have_content "#{answer.body}(the best answer)"
    expect(page).to_not have_content "#{best_answer.body}(the best answer)"
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