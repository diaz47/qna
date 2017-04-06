require 'rails_helper'

feature 'Sign in && up with facebook provider' do
  background { OmniAuth.config.test_mode = true }

  given!(:user){ create(:user)}

  scenario 'existed user try to sign in' do
    OmniAuth.config.add_mock(:facebook, uid: '12345678', info: {email: user.email})
    visit new_user_session_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from facebook account.'
  end

  scenario 'new user try to sign in' do
    OmniAuth.config.add_mock(:facebook, uid: '12345678', info: {email: 'newuser@mail.ru'})
    visit new_user_session_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from facebook account.'
  end
end