require 'rails_helper' 

feature 'Show questions on the page' do
  given(:questions) { create_list(:question, 2) }
  
  scenario 'User can see all questions on page' do
    questions
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end
end