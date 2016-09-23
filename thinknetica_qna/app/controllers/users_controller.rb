class UsersController < ApplicationController
  #authorize_resource

  def build_by_email
    auth = session['omniauth.data']

    @user = User.build_from_omniauth_params(params, auth)
    if @user.confirmed_at
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Successfully authenticated from #{auth["provider"].capitalize} account."
    else
      redirect_to :new_user_registration
    end
  end
end
