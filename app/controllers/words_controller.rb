class WordsController < ApplicationController
  def index
    @categories = Category.all
    filter_type = params[:word_filter] || Settings.word_filter.last
    @words = Word.send(filter_type, current_user.id).
      filter_by_category(params[:category_id]).
      paginate page: params[:page], per_page: Settings.per_page
  end
end
