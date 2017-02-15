require 'rails_helper' 

feature 'Show answers on the page' do
  given(:question) { create(:question)}
  given!(:answers) { create_list(:answer, 5, question: question)}

  scenario 'User can see answers for question' do
    visit question_path(question)
    answers

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end