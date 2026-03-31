require 'rails_helper'

RSpec.describe 'Reviewモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { review.valid? }

    let(:user) { create(:user) }
    let(:book) { create(:book, user_id: user.id) }
    let!(:review) { build(:review, user_id: user.id, book_id: book.id) }

    context 'scoreカラム' do
      it '空欄でないこと' do
        review.score = nil
        is_expected.to eq false
      end
      it '1以上であること: 1は〇' do
        review.score = 1
        is_expected.to eq true
      end
      it '5以下であること: 5は〇' do
        review.score = 5
        is_expected.to eq true
      end
      it '1未満は×: 0は×' do
        review.score = 0
        is_expected.to eq false
      end
      it '5超過は×: 6は×' do
        review.score = 6
        is_expected.to eq false
      end
      it '同じユーザーが同じ本に2回評価できないこと' do
        create(:review, user_id: user.id, book_id: book.id)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Review.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Bookモデルとの関係' do
      it 'N:1となっている' do
        expect(Review.reflect_on_association(:book).macro).to eq :belongs_to
      end
    end
  end
end
