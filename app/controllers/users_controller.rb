class UsersController < ApplicationController
  before_action :logged_in_user, :correct_user, only: [:edit, :update]
  before_action :logged_in_user, only: :index
  before_action :load_user, only: :show

  def index
    @users = User.order(created_at: :desc).paginate page: params[:page],
      per_page: Settings.per_page
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:success] = t ".activation_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  def following
    @title = t ".title"
    @user  = User.find_by id: params[:id]
    @users = @user.following.paginate(page: params[:page])
    render :show_follow
  end

  def followers
    @title = t ".title"
    @user  = User.find_by id: params[:id]
    @users = @user.followers.paginate(page: params[:page])
    render :show_follow
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :telephone, :sex, :password,
      :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t ".not_found"
      redirect_to root_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    unless @user == current_user
      flash[:danger] = t ".only_current_user"
    end
  end
end
