class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :books, dependent: :destroy # アソシエーション
  has_many :favirites, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  has_one_attached :profile_image

  validates :name, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }
  validates :password, length: { minimum: 6 }, allow_nil: true


end
