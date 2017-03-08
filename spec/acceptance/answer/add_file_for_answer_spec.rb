require 'rails_helper'

feature 'Add file to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Author try add file to answer', js: true do
    fill_in 'Write your answer', with: 'my answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'create answer'

    within '.answer_list' do
      expect(page).to have_link'spec_helper.rb'
    end
  end 
end