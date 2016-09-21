class UsersController < ApplicationController
  def ask_email
    binding.pry
    #@user = User.find(params[:id])
    @user.update(params)
    sign_in_and_redirect @user, event: :authentication
  end
end
