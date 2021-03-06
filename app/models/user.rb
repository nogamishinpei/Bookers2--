class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
   devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :name, uniqueness: true, length: { minimum:2, maximum: 20}
  validates :introduction, length: { maximum: 50 }

  has_many :books, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  
  #フォロー/フォロワー機能部分
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  
  has_many :followings, through: :relationships, source: :followed
  
  
  attachment :profile_image
  
  #フォロー/フォロワー機能追加部分
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  def following?(user)
    followings.include?(user)
  end

end
