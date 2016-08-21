class Word < ActiveRecord::Base
  belongs_to :category
  has_many :word_answers, dependent: :destroy
  has_many :results
  has_many :lessons, through: :results
  validates :content, :category_id, presence: true
  scope :filter_by_category, -> category_id do
    where category_id: category_id if category_id.present?
  end

  scope :show_all, -> user_id {}

  scope :learned, -> user_id do
    joins(:lessons).distinct.
      where(lessons: {is_complete: true, user_id: user_id})
  end

  scope :unlearned, -> user_id do
    where.not id: Word.learned(user_id)
  end

  accepts_nested_attributes_for :word_answers,
    reject_if: proc {|attributes| attributes["content"].blank?},
    allow_destroy: true
end
