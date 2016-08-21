class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email_or_phone(params[:session][:q].downcase).first
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to root_url
    else
      flash[:danger] = t ".flash"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
