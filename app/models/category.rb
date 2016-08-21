class Category < ActiveRecord::Base
  has_many :words
  has_many :lessons

  validates :conten, presence: true, length: {minimum: 3, maximum: 150}
end
