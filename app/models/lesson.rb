class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :results
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :category_id, presence: true
  before_create :assign_word

  accepts_nested_attributes_for :results,
    reject_if: proc {|attributes| attributes[:word_answer_id].blank?}

  def score
    "#{self.results.select{|result| result if result.correct_answer}.count}
      /#{Settings.questions_in_lesson}"
  end

  def assign_word
    self.category.words.shuffle.take(Settings.questions_in_lesson).
      each do |word|
      self.results.build word_id: word.id
    end
  end

  def check_create_lesson?
    (self.category && self.category.words.count >= Settings.minimum_words) ?
      true : false
  end
end
