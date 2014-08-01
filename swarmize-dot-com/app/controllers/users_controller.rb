class UsersController < ApplicationController
  before_filter :scope_to_user, :except => %w{index new create}
  before_filter :count_swarms, :only => %w{show open live closed}

  def index
    @users = User.paginate(:page => params[:page])
  end

  def show
    @swarms = @user.swarms.paginate(:page => params[:page])
  end

  def open
    @swarms = @user.swarms.yet_to_launch.paginate(:page => params[:page])
  end

  def live
    @swarms = @user.swarms.live.paginate(:page => params[:page])
  end
  
  def closed
    @swarms = @user.swarms.closed.paginate(:page => params[:page])
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
    @all_swarms_count = @user.swarms.count
    @open_swarms_count = @user.swarms.yet_to_launch.count
    @live_swarms_count= @user.swarms.live.count
    @closed_swarms_count = @user.swarms.closed.count
  end
end
