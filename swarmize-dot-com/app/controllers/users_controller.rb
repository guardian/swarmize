class UsersController < ApplicationController
  before_filter :scope_to_user, :except => %w{index new create}

  def index
    @users = User.paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @swarms = @user.swarms.paginate(:page => params[:page], :per_page => 20)
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
end
