class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user, :load_category, :verify_admin

  def index
    @categories = Category.paginate page: params[:page],
      per_page: Settings.category.per_page
  end

  def show
    @category = Category.find_by id: params[:id]
    if @category.nil?
      flash[:danger] = t "waring"
      render :index
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "addedcategory"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "admin.success"
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "admin.deletecategory"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to admin_categories_path
  end

  private
  def category_params
      params.require(:category).permit(:conten)
  end

  def load_category
    @category = Category.find_by id: params[:id]
  end
end
