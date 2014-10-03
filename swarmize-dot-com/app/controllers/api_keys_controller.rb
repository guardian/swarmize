class ApiKeysController < ApplicationController
  before_filter :scope_to_swarm
  before_filter :check_user_has_permissions_on_swarm

  def index
  end

  def new
  end

  def create
    APIKey.create(@swarm.token, @current_user.email)
    flash[:success] = "Key created."
    redirect_to swarm_api_keys_path(@swarm)
  end

  def destroy
    APIKey.delete(params[:id])
    flash[:success] = "Key deleted."
    redirect_to swarm_api_keys_path(@swarm)
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find_by(token: params[:swarm_id])
  end

  def check_user_has_permissions_on_swarm
    unless AccessPermission.can_alter?(@swarm, @current_user)
      flash[:error] = "You don't have permission to do that."
      redirect_to root_path
    end
  end

end
