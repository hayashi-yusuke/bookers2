class BooksController < ApplicationController
  before_action :require_authentication # アクションの前にログイン確認
  before_action :correct_book_user, only: [:edit, :update, :destroy]


  def index
    @user = Current.session.user
    @new_book = Book.new

     # paramsで並び順を切り替える
    if params[:sort] == "rate"
      # 評価の高い順
      @books = Book.left_joins(:reviews)
                  .group(:id)
                  .order(Arel.sql("AVG(reviews.score) DESC"))
    else
      # 新着順（デフォルト）
      @books = Book.order(created_at: :desc)
    end
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @new_book = Book.new
    @book_comment = BookComment.new

    # 詳細ページを開くたびに閲覧数を+1する
    @book.increment!(:views_count)
  end

  def new
    @book = Book.new
  end

  def create
    @new_book = Book.new(book_params)
    @new_book.user = Current.session.user
    if @new_book.save
      Review.create(user: Current.session.user, book: @new_book, score: params[:book][:score])
      # タグを保存する処理　←ここから
      if params[:book][:tag_name].present?
        tag = Tag.find_or_create_by(name: params[:book][:tag_name])
        @new_book.tags << tag
      end
      redirect_to book_path(@new_book), notice: "Book created successfully!"
    else
      @user = Current.session.user
      @books = Book.all
      render 'users/show', status: :unprocessable_entity
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "Book updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def correct_book_user
    @book = Book.find(params[:id])
    unless @book.user == Current.session.user
      redirect_to books_path, alert: "Access error! You can't edit other users' books."
    end
  end
  
end