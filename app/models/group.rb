class Group < ApplicationRecord
  # オーナーはUserモデルと紐付く
  belongs_to :owner, class_name: "User"

  has_many :group_users, dependent: :destroy
  has_many :members, through: :group_users, source: :user

  # バリデーション
  validates :name, presence: true, length: { maximum: 50 }
  validates :introduction, presence: true, length: { maximum: 200 }
end
