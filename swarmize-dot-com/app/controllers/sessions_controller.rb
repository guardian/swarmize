class SessionsController < ApplicationController
  def callback
    if User.is_valid_email?(request.env['omniauth.auth'].info.email)
      @user = User.first_or_create_from_info_hash(request.env['omniauth.auth'].info)
      session[:user_id] = @user.id
      flash[:success] = "You've been successfully logged in to Swarmize."
      redirect_back_or_default(root_path)
    else
      flash[:error] = "We're sorry, but you can't log in with that email address."
      redirect_to root_path
    end
  end

  def logout
    # render a logout screen
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You've been logged out of Swarmize."
    redirect_to root_path
  end
end
