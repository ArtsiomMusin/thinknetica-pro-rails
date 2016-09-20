class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authenticate_provider

  def facebook
  end

  private

  def authenticate_provider
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    end
  end
end
