class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def logged_in_user
    unless logged_in?
      flash[:danger] = t "users.require_login"
      redirect_to login_path
    end
  end

  def verify_admin
    unless current_user.is_admin?
      flash[:danger] = t "check_admin"
      redirect_to root_path
    end
  end
end
