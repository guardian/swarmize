class UsersController < ApplicationController
  before_filter :check_for_user, :only => :draft
  before_filter :check_for_admin, :except => %w{show live closed draft}
  before_filter :scope_to_user, :except => %w{index new create}
  before_filter :check_can_see_drafts, :only => :draft
  before_filter :count_swarms, :only => %w{show draft live closed}

  def index
    @users = User.paginate(:page => params[:page])
  end

  def show
    @swarms = @user.swarms.unspiked.paginate(:page => params[:page])
  end

  def draft
    @swarms = @user.swarms.unspiked.draft.paginate(:page => params[:page])
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

  def check_can_see_drafts
    unless AccessPermission.can_see_user_drafts?(@current_user, @user)
      flash[:error] = "You don't have permission to do that."
      redirect_to root_path
    end
  end

  def count_swarms
    if @current_user
      @all_swarms_count = @user.swarms.unspiked.count
      @open_swarms_count = @user.swarms.unspiked.draft.count
    else
      @all_swarms_count = @user.swarms.unspiked.publicly_visible.count
    end
    @live_swarms_count= @user.swarms.unspiked.live.count
    @closed_swarms_count = @user.swarms.unspiked.closed.count
  end
end
