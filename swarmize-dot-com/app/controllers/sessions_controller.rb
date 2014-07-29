class SessionsController < ApplicationController
  def callback
    logger.debug request.env["omniauth.auth"]
    # inside the auth hash
    # auth_hash['info']['email'] = tom@infovore.org
    # auth_hash['info']['name'] = Tom Armitage
    # auth_hash['info']['image'] = 'https://lh3.googleusercontent.com/-PgrxxJsXdX0/AAAAAAAAAAI/AAAAAAAAABA/KGZmoHx_8tc/photo.jpg?sz=50'
    #
    #  :credentials => {
        #:token => "token",
        #:refresh_token => "another_token",
        #:expires_at => 1354920555,
        #:expires => true
    #},
    #
    # first: check it's a valid email
    # if it is
      # find or create the user by email
      # session user = @user
      # session
    if User.is_valid_email?(request.env['omniauth.auth'].info.email)
      @user = User.first_or_create_from_info_hash(request.env['omniauth.auth'].info)
      session[:user_id] = @user.id
      flash[:success] = "You've been successfully logged in to Swarmize."
      redirect_to root_path
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
