class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :books, dependent: :destroy # アソシエーション
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  has_one_attached :avatar

  validates :name, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }

end
