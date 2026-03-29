class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :books, dependent: :destroy # アソシエーション
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "receiver_id", dependent: :destroy
  # グループ機能
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  has_one_attached :profile_image

  # グループ参加機能
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users


  #フォロー機能
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  #指定したユーザーをフォロー
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  #指定したユーザーのフォローを解除
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  #指定したユーザーをフォローしているかを判定
  def following?(user)
    followings.include?(user)
  end

  validates :name, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }
  validates :password, length: { minimum: 6 }, allow_nil: true

end
