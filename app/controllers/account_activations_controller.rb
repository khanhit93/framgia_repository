class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activation? && user.authenticate?(:activation, params[:id])
      user.activate_user
      log_in user
      flash[:success] =  t ".success"
      redirect_to user
    else
      flash[:danger] = t ".fail"
      redirect_to root_url
    end
  end
end
