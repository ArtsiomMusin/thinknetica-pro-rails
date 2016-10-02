class Api::V1::ProfilesController < Api::V1::BaseController
  def index
    authorize! :get_all, :profile
    respond_with User.all_but_current(current_resource_owner)
  end

  def me
    authorize! :get_me, :profile
    respond_with current_resource_owner
  end
end
