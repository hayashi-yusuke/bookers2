class Book < ApplicationRecord
    belongs_to :user  # アソシエーション
    has_many :favorites, dependent: :destroy
    has_many :book_comments, dependent: :destroy
    has_many :reviews, dependent: :destroy
    has_many :book_tags, dependent: :destroy
    has_many :tags, through: :book_tags

    validates :title, presence: true
    validates :body, presence: true, length: { maximum: 200 }

    def favorited_by?(user)
      favorites.exists?(user_id: user.id)
    end
end
