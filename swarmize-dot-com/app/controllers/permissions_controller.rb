class PermissionsController < ApplicationController
  before_filter :scope_to_swarm
  before_filter :check_for_user, only: :index
  before_filter :check_user_can_alter_permissions, except: :index
  before_filter :scope_to_permission, only: %w{destroy}

  def index
    @access_permissions = @swarm.access_permissions 
  end

  def create
    if params[:email].strip.blank?
      flash[:error] = "You must specify an email address to give permission to!"
      redirect_to swarm_permissions_path(@swarm) and return
    end

    if !EmailValidator.is_valid_email?(params[:email])
      flash[:error] = "You can only give permissions to users with Guardian email addresses."
      redirect_to swarm_permissions_path(@swarm) and return
    end

    email = EmailValidator.normalize_email(params[:email])

    @user = User.find_by email: email
    ap = AccessPermission.where(swarm: @swarm, email: email)
    if(!ap.empty?)
      flash[:error] = "That user already has permissions on this swarm."
      redirect_to swarm_permissions_path(@swarm) and return
    else
      @access_permission = AccessPermission.create(swarm: @swarm,
                                                   user: @user,
                                                   creator: @current_user,
                                                   email: email)
      PermissionMailer.permission_email(email, @swarm).deliver
      flash[:success] = "#{email} has been given permission to alter this swarm. They've been sent an email notifying them of this fact!"
      redirect_to swarm_permissions_path(@swarm) and return
    end
  end

  def destroy
    email = @permission.email
    @permission.destroy
    flash[:success] = "#{email} no longer has permissions on this swarm."
    redirect_to swarm_permissions_path(@swarm)
  end

  private

  def scope_to_swarm
    @swarm = Swarm.find_by(token: params[:swarm_id])
  end

  def check_user_can_alter_permissions
    unless AccessPermission.can_alter_permissions?(@swarm, @current_user)
      flash[:error] = "You don't have permission to do that."
      redirect_to @swarm
    end
  end

  def scope_to_permission
    @permission = @swarm.access_permissions.find(params[:id])
  end

end
