class Book < ApplicationRecord
    belongs_to :user  # アソシエーション

    validates :title, presence: true
    validates :body, presence: true, length: { maximum: 200 }

end
