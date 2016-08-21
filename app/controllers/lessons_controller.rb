class LessonsController < ApplicationController
  before_action :logged_in_user, :load_lesson
  before_action :verify_current_user, :verify_complete, only: [:edit, :update]
  before_action :verify_uncomplete, only: :show
  before_action :load_categories, only: :index
  before_action :load_category, only: :create

  def index
    @lesson = Lesson.new
    @lessons = current_user.lessons.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def show
  end

  def create
    @lesson = Lesson.new category_id: lesson_params[:category_id],
      user_id: current_user.id
    if @lesson.check_create_lesson?
      if @lesson.save
        current_user.create_activity Activity.activity_types[:create_lesson]
        flash[:success] = t "lesson.success"
        redirect_to lessons_path
      end
    else
      flash[:danger] = t "createfail"
      redirect_to new_lesson_path
    end
  end

  def edit
    unless @lesson
      flash[:danger] = t "lesson.notlesson"
      redirect_to lessons_path
    else
      current_user.create_activity Activity.activity_types[:learn_lesson]
    end
  end

  def update
    params[:lesson][:is_complete] = true if
      params[:commit] == t("lesson.submit")
    if @lesson.update_attributes lesson_params
      current_user.create_activity Activity.activity_types[:finished]
      flash[:success] = (params[:commit] == (t "lesson.submit")?
        (t "lesson.over") : (t "lesson.save"))
      redirect_to lessons_path
    else
      flash[:danger] = t "lesson.finish_fail"
      redirect_to edit_lesson_path @lesson
    end
  end

  private
  def load_lesson
    @lesson = Lesson.find_by id: params[:id]
  end

  def verify_current_user
    unless @lesson.user == current_user
      flash[:danger] = t "lesson.permission"
      redirect_to lessons_path
    end
  end

  def verify_complete
    if @lesson.is_complete?
      redirect_to lesson_path @lesson
    end
  end

  def verify_uncomplete
    unless @lesson.is_complete?
      flash[:warning] = t "lesson.learning"
      redirect_to edit_lesson_path @lesson
    end
  end

  def load_categories
    @categories = Category.all
  end

  def load_category
    @category = Category.find_by id: params[:category_id]
    unless @category
      flash[:danger] = t "lesson.permission"
      redirect_to lessons_path
    end
  end

  def lesson_params
    params.require(:lesson).permit :category_id, :is_complete,
      results_attributes: [:id, :word_answer_id, :word_id,:is_complete]
  end
end
