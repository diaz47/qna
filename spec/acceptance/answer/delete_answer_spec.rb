require_relative '../acceptance_helper'

feature 'Delete answer ' do
  given(:user){ create(:user) }
  given(:user_2){ create(:user_2) }

  given(:question){ create(:question)}
  given!(:answer){ create(:answer, user: user, question: question)}

  scenario 'Author of answer try delete answer' do
    sign_in(user)
    visit question_path(question)

    answer
    click_on 'Delete answer'

    expect(page).to have_content 'Your answer was success deleted'
    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario 'No Author of answer try delete answer' do
    sign_in(user_2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'No authenticated user try delete answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end