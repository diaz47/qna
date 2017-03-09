require 'rails_helper'

feature 'Delete file of answer' do
  given(:author){ create(:user) }
  given(:some_user){ create(:user) }
  given(:question){ create(:question)}
  given!(:answer){ create(:answer, user: author, question: question)}
  given!(:attachment){ create(:attachment, attachable: answer)}

  scenario 'Authnticated user try delete file of answer', js: true do
    sign_in(author)
    visit question_path(question)
    answer
    attachment

    within '.answer_list' do
      click_on "Delete"
      expect(page).to_not have_link attachment.file.filename
    end
  end
  scenario 'Authnticated user try delete other file of answer', js: true do
    sign_in(some_user)
    visit question_path(question)
    answer
    attachment

    within '.answer_list' do
      expect(page).to_not have_link "Delete"
    end
  end
  scenario 'No Authnticated user try delete file of answer', js: true do
    visit question_path(question)
    answer
    attachment

    within '.answer_list' do
      expect(page).to_not have_link "Delete"
    end
  end
end