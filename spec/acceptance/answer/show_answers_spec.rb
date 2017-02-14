require 'rails_helper' 

feature 'Show answers on the page' do
  given(:question) { create(:question_with_answer)}

  scenario 'User can see answers for question' do
    visit question_path(question)

    expect(page).to have_content 'body3'
  end
end