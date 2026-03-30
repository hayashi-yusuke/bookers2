class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  # scoreが空はダメ、1〜5の数字のみOK
  validates :score, presence: true, inclusion: { in: 1..5 }

  # 同じユーザーが同じ本に2回評価できないようにする
  validates :user_id, uniqueness: { scope: :book_id }
end