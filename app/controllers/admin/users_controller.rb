class Admin::UsersController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_user, only: [:destroy, :update]

  def index
    @users = User.order(created_at: :desc).paginate page: params[:page],
      per_page: Settings.per_page
  end

  def update
    if @user.update_attribute :is_admin, params[:is_admin]
      flash[:success] = t ".success"
      redirect_to admin_users_url
    else
      flash[:danger] = t ".fail"
      redirect_to admin_users_url
    end
  end

  def destroy
    unless @user.is_admin?
      if @user.destroy
        flash[:success] = t ".message", name: @user.name
      else
        flash[:danger] = t ".fail"
      end
    else
      flash[:warning] = t ".fail_destroy"
    end
    redirect_to admin_root_url
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t ".not_found"
      redirect_to admin_root_url
    end
  end
end
