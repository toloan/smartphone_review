class User < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name, :email]
  
  before_save :downcase_email
  
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  mount_uploader :avatar, AvatarUploader
    
    
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,  presence: true, length:
    {maximum: 30}
  validates :email, presence: true,
    length: {maximum: 50},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: 6, maximum: 20}, allow_nil: true
  has_secure_password
  
  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
  
  private
  def downcase_email
    email.downcase!
  end
end
