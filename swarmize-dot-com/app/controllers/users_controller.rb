class UsersController < ApplicationController
  before_filter :scope_to_user, :except => %w{index new create}

  def index
    @users = User.all
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
