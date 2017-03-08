require 'rails_helper'

feature 'Add file to question' do 
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'Author try add file to question' do
    fill_in 'Title', with: 'My title'
    fill_in 'Body', with: 'My question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create Question'

    expect(page).to have_link'spec_helper.rb'
  end 
end