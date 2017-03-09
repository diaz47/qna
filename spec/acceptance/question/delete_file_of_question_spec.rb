require 'rails_helper'

feature 'Delete file of answer' do
  given(:author){ create(:user) }
  given(:some_user){ create(:user) }
  given(:question){ create(:question, user: author)}
  given!(:attachment){ create(:attachment, attachable: question)}

  scenario 'Authnticated (author) user try delete file of question', js: true do
    sign_in(author)
    visit question_path(question)
    attachment
    within '.question .attach_list' do
      click_on "Delete"
      expect(page).to_not have_link attachment.file.filename
    end
  end
  scenario 'Authnticated (no author) user try delete other file of question', js: true do
    sign_in(some_user)
    visit question_path(question)
    attachment

    within '.question .attach_list' do
      expect(page).to_not have_link "Delete"
    end
  end
  scenario 'No Authnticated user try delete file of answer', js: true do
    visit question_path(question)
    attachment

    within '.question .attach_list' do
      expect(page).to_not have_link "Delete"
    end
  end
end