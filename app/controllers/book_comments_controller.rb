class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    comment = Current.user.book_comments.new(book_comment_params)
    comment.book_id = @book.id
    comment.save
    @book_comment = BookComment.new
  end
  def destroy
    comment = BookComment.find(params[:id])
    @book = comment.book
    comment.destroy
    @book_comment = BookComment.new
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
