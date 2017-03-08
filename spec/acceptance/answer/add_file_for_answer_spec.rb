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

  scenario 'Author try add files to answer', js: true do
    fill_in 'Write your answer', with: 'my answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'add attachments'

    within page.all('.attach_form').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'create answer'

    within '.answer_list' do
      expect(page).to have_link'spec_helper.rb'
      expect(page).to have_link'rails_helper.rb'
    end
  end
end