class CategoriesController < ApplicationController
  before_action :load_cateogry, only: :show

  def index
    @categories = Category.order(created_at: :desc).paginate page:
      params[:page], per_page: Settings.per_page
  end

  def new
    @category = Category.new
  end

  def show
    @words = @category.words.paginate page: params[:page],
      per_page: Settings.per_page
  end

  private
  def load_cateogry
    @category = Category.find_by id: params[:id]
    unless @category
      flash[:danger] = t ".not found"
      redirect_to categories_url
    end
  end
end
