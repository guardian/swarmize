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
      redirect_to login_path
    end
  end

  def logged_in?
    session[:user_id] != nil
  end

  def login_path
    "/auth/google_oauth2"
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
      session.delete(:return_to)
      redirect_to(redirect_url)
    else
      redirect_to(default)
    end
  end
end
