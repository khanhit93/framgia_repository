class Result < ActiveRecord::Base
  belongs_to :word
  belongs_to :word_answer
  belongs_to :lesson

  scope :in_lesson, -> (lesson) {where lesson_id: lesson.id}
  delegate :correct_answer, to: :word_answer, allow_nil: true
end
