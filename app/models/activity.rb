class Activity < ActiveRecord::Base
  belongs_to :user
  validates :content, presence: true

  enum activity_types: [:follow, :unfollow, :create_lesson, :finished,
    :learn_lesson]
  default_scope -> {order(created_at: :desc)}
end
