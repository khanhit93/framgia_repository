class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  has_many :activities
  has_many :lessons
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: "followed_id", dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length: {maximum: 50}
  validates :telephone, presence: true, length: {in: 9..25},
    uniqueness: true
  validates :email, presence: true, length: {maximum: 50},
    format: {with: EMAIL_REGEX}, uniqueness: {case_sentitive: false}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  before_create :create_activation_digest
  before_save :downcase_email

  scope :find_by_email_or_phone, ->q do
    where "email=? OR telephone =?", q, q
  end

  def create_activity action_type, target_id = ""
    user = User.find_by id: target_id
    if action_type == 0
      activity_content = "You have follow #{user.name}"
    elsif action_type == 1
      activity_content = "You have unfollow #{user.name}"
    elsif action_type == 2
      activity_content = "You created new lesson"
    elsif action_type == 3
      activity_content = "You finished lesson"
    elsif action_type == 4
      activity_content = "You learned lesson"
    end
    self.activities.build(user_id: self.id, target_id: target_id,
      content: activity_content).save
  end

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def get_sex
    self.sex ? "Maile" : "Female"
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticate? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def activate_user
    update_attributes activation: true, active_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def follow other_user
    active_relationships.create followed_id: other_user.id
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include? other_user
  end

  private
  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
