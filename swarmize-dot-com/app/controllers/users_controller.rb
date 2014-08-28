class UsersController < ApplicationController
  before_filter :check_for_admin, :except => %w{show yet_to_open live closed}
  before_filter :scope_to_user, :except => %w{index new create}
  before_filter :count_swarms, :only => %w{show yet_to_open live closed}

  def index
    @users = User.paginate(:page => params[:page])
  end

  def show
    @swarms = @user.swarms.unspiked.paginate(:page => params[:page])
  end

  def yet_to_open
    @swarms = @user.swarms.unspiked.yet_to_launch.paginate(:page => params[:page])
  end

  def live
    @swarms = @user.swarms.unspiked.live.paginate(:page => params[:page])
  end
  
  def closed
    @swarms = @user.swarms.unspiked.closed.paginate(:page => params[:page])
  end

  def delete
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  private

  def scope_to_user
    @user = User.find(params[:id])
  end

  def count_swarms
    @all_swarms_count = @user.swarms.unspiked.count
    @open_swarms_count = @user.swarms.unspiked.yet_to_launch.count
    @live_swarms_count= @user.swarms.unspiked.live.count
    @closed_swarms_count = @user.swarms.unspiked.closed.count
  end
end
