require 'rails_helper'

feature 'Add new Questions' do
  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 2) }

  scenario 'Authenticated user try to create valid question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'My title'
    fill_in 'Body', with: 'My question'
    click_on 'Create Question'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'My title'
    expect(page).to have_content 'My question'
  end

  scenario 'Authenticated user try to create invalid question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: 'My question'
    click_on 'Create Question'

    expect(page).to have_content "Title can't be blank"
  end

  scenario 'No Authenticated user try to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

  context 'multiple session' do
    scenario 'question appears in another users`s browser' do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
      Capybara.using_session('guest') do
        visit questions_path
      end
      Capybara.using_session('user') do
        visit questions_path
        click_on 'Ask question'
        fill_in 'Title', with: 'My title'
        fill_in 'Body', with: 'My question'
        click_on 'Create Question'

        expect(page).to have_content 'My title'
        expect(page).to have_content 'My question'
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'My title'
      end
    end
  end
end