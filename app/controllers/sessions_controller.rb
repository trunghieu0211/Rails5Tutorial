class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        "1" == params[:session][:remember_me] ? remember(user) : forget(user)
        flash[:success] = t ".success"
        redirect_to user
      else
        flash[:warning] = t ".account_not_activated"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t ".login_error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
