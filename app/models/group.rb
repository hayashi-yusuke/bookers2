class Group < ApplicationRecord
  # オーナーはUserモデルと紐付く
  belongs_to :owner, class_name: "User"

  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  validates :introduction, presence: true, length: { maximum: 200 }
end
