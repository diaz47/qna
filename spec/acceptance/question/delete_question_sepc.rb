require 'rails_helper' 

feature 'Delete question' do 
  scenario 'Author of question try delete question' do
    sign_in(user)
    create_question
    click_on 'Delete question'

    expect(page).to have_content 'Your question was deleted'
    expect(page).to_not have_content 'My title'
    expect(current_path).to eq questions_path
  end
  

  scenario 'No Author of question try delete question' do
    sign_in(user)
    visit question_path(questions[0])

    expect(page).to_not have_content 'Delete question'
    expect(current_path).to eq question_path(questions[0])
  end
end