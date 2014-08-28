class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_up_current_user

  def set_up_current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end

  def check_for_user
    if !logged_in?
      store_location
      redirect_to login_path and return
    end
  end

  def check_for_admin
    if !logged_in?
      store_location
      redirect_to login_path and return
    end

    unless @current_user.is_admin?
      flash[:error] = "You don't have permission to do that."
      redirect_to root_path
    end
  end

  def logged_in?
    session[:user_id] != nil
  end

  def store_location
    if request.get?
      session[:return_to] = request.original_url
    else
      session[:return_to] = request.referer
    end
  end

  def redirect_back_or_default(default = root_url)
    if session[:return_to]
      redirect_url = session[:return_to]
      logger.debug("Redirect URL is #{redirect_url}")
      session.delete(:return_to)
      redirect_to(redirect_url)
    else
      redirect_to(default)
    end
  end
end
