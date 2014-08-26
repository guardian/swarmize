class PermissionsController < ApplicationController
  before_filter :scope_to_swarm
  before_filter :check_user_can_alter_permissions
  before_filter :scope_to_permission, :only => %w{edit update delete destroy}

  def create
    @access_permission = AccessPermission.create(:swarm => @swarm,
                                                 :creator => @current_user,
                                                 :email => params[:email])
  end

  def destroy
    @permission.destroy
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find_by(token: params[:swarm_id])
  end

  def check_user_can_alter_permissions
    if @swarm.user != @current_user
      flash[:warning] = "You don't have permission to do that."
      redirect_to @swarm
    end
  end

  def scope_to_permission
    @permission = @swarm.access_permissions.find(params[:id])
  end

end
