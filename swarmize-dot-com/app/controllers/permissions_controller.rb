class PermissionsController < ApplicationController
  before_filter :scope_to_swarm
  before_filter :check_user_can_alter_permissions
  before_filter :scope_to_permission, :only => %w{edit update delete destroy}

  def create
    unless params[:email].blank?
      @user = User.find_by email: params[:email]
      ap = AccessPermission.where(:swarm => @swarm, :email => params[:email])
      if(ap.empty?)
        @access_permission = AccessPermission.create(:swarm => @swarm,
                                                     :user => @user,
                                                     :creator => @current_user,
                                                     :email => params[:email])
        PermissionMailer.permission_email(params[:email], @swarm).deliver
      end
    end
    render json: @access_permission.to_json(:include => :user)
  end

  def destroy
    @permission.destroy
    render :nothing => true
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find_by(token: params[:swarm_id])
  end

  def check_user_can_alter_permissions
    unless AccessPermission.can_alter_permissions?(@swarm, @current_user)
      flash[:warning] = "You don't have permission to do that."
      redirect_to @swarm
    end
  end

  def scope_to_permission
    @permission = @swarm.access_permissions.find(params[:id])
  end

end
