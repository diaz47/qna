require 'rails_helper'

feature 'Search' do
  given!(:user){ create(:user) }
  given!(:question){ create(:question) }
  given!(:answer){ create(:answer, question: question) }
  given!(:comment){ create(:comment, commentable: question, user: user) }

  background do
    index
    visit root_path
  end

  scenario 'User try find item with invalid query', sphinx: true do
    fill_in 'query', with: ''
    click_on 'Search'

    expect(page).to have_content 'Results not found'
  end

  scenario 'User try find item with valid quety in everywere', sphinx: true do
    select 'Everyware', from: 'source'
    fill_in 'query', with: question.title
    click_on 'Search'

    expect(page).to have_content question.title
  end

  describe 'Find by Model' do
    scenario "User try find item in Question", sphinx: true do
      select "Question", from: 'source'
      fill_in 'query', with: question.title
      click_on 'Search'

      expect(page).to have_content question.title
    end

    scenario "User try find item in Comment", sphinx: true do
      select "Comment", from: 'source'
      fill_in 'query', with: comment.body
      click_on 'Search'

      expect(page).to have_content comment.body
    end

    scenario "User try find item in Answer", sphinx: true do
      select "Answer", from: 'source'
      fill_in 'query', with: answer.body
      click_on 'Search'

      expect(page).to have_content answer.body
    end
  end
end
