require 'rails_helper' 

feature 'Delete question' do 
  given(:user){ create(:user)}
  given(:question){ create(:question, user: user)}
  given(:question_2){ create(:question)}

  scenario 'Author of question try delete question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question was deleted'
    expect(page).to_not have_content 'My title'
    expect(current_path).to eq questions_path
  end
  

  scenario 'No Author of question try delete question' do
    sign_in(user)
    visit question_path(question_2)

    expect(page).to_not have_content 'Delete question'
    expect(current_path).to eq question_path(question_2)
  end

  scenario 'No authenticated user try delete question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
    expect(current_path).to eq question_path(question)
  end
end