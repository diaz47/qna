require 'rails_helper'

feature 'Show questions on the page' do
  given(:questions) { create_list(:question, 5) }
  
  scenario 'User can see all questions on page' do
    questions
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end