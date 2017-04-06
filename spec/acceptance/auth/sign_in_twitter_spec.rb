require 'rails_helper'

feature 'Sign in && up with twitter provider' do
  background { OmniAuth.config.test_mode = true }

  given!(:user){ create(:user)}

  scenario 'existed user try to sign in' do
    OmniAuth.config.add_mock(:twitter, uid: '12345678', info: {email: user.email})
    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from twitter account.'
  end

  scenario 'new user try to sign in' do
    OmniAuth.config.add_mock(:twitter, uid: '12345678', info: {email: 'newuser@mail.ru'})
    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from twitter account.'
  end
end