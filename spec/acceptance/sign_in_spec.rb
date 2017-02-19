require_relative 'acceptance_helper'

feature 'User sign in' do
  given(:user) { create(:user) }
  scenario 'Registred user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'No Registered try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@mail.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'User try registration in service' do
    visit new_user_registration_path
    fill_in 'Email', with: 'myemail@mail.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.' 
    expect(current_path).to eq root_path
  end

  scenario 'User try Log out from the service' do
    User.create!(email: 'test@mail.ru', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'test@mail.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end