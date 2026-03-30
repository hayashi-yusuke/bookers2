class ReviewsController < ApplicationController
  def create
    # URLから本のIDを取得して、その本を探す
    book = Book.find(params[:book_id])

    # ログイン中のユーザーと本に紐づけてレビューを作成する
    review = Review.new(review_params)
    review.user_id = current_user.id
    review.book_id = book.id

    review.save
    # 保存後は本の詳細ページに戻る
    redirect_to book_path(book)
  end

  private

  def review_params
    params.require(:review).permit(:score)
  end
end