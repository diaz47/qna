class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth_from(:facebook)
  end

  def twitter
    auth_from(:twitter)
  end

  private
  def auth_from(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.to_s) if is_navigational_format?
    end
  end
end