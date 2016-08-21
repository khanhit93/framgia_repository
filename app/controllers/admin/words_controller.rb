class Admin::WordsController < ApplicationController
  before_action :logged_in_user, :verify_admin, :load_categories
  before_action :load_word, only: [:edit, :update, :destroy]

  def index
    @words = Word.filter_by_category(params[:category_id]).
      paginate page: params[:page], per_page: Settings.per_page
  end

  def new
    @word = Word.new
    4.times{@word.word_answers.build}
  end

  def create
    @word = Word.new word_params
    if @word.save
      flash[:success] = t ".success", word: @word.content
      redirect_to admin_words_url
    else
      4.times{@word.word_answers.build}
      render :new
    end
  end

  def edit
  end

  def update
    if @word.update_attributes word_params
      flash[:success] = t ".success", word: @word.content
      redirect_to admin_words_url
    else
      flash[:danger] = t ".failed"
      render :edit
   end
  end

  def destroy
    if @word.destroy
      flash[:success] = t ".message_scucess", word: @word.content
      redirect_to admin_words_url
    end
  end

  private
  def word_params
    params.require(:word).permit :content, :category_id,
      word_answers_attributes: [:id, :content, :correct_answer]
  end

  def load_categories
    @categories = Category.all
  end

  def load_word
    @word = Word.find_by id: params[:id]
    unless @word
      flash[:danger] = t ".not_found"
      redirect_to admin_root_url
    end
  end
end
