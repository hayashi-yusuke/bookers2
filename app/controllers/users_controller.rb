class UsersController < ApplicationController
  # 認証をスキップ: サインアップ（new, create）はログイン前に行うため
  allow_unauthenticated_access only: [ :new, :create ]
  before_action :correct_user, only: [ :edit, :update ]


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url, notice: "Welcome! You have signed up successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @users = User.all
    @user = Current.session.user
    @new_book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @new_book = Book.new
    @books = @user.books

    # 今日の投稿数
    @today_books_count = @user.books.where(created_at: Time.zone.now.all_day).count

    # 前日の投稿数
    @yesterday_books_count = @user.books.where(created_at: 1.day.ago.all_day).count

    # 今日 / 前日の比率（前日が0のときは0にする）
    @today_yesterday_rate = @yesterday_books_count == 0 ? "0%" : "#{(@today_books_count.to_f / @yesterday_books_count * 100).round}%"

    # 今週の投稿数（土曜始まり）
    @this_week_books_count = @user.books.where(created_at: Time.zone.now.beginning_of_week(:saturday)..Time.zone.now.end_of_week(:friday)).count

    # 先週の投稿数（土曜始まり）
    @last_week_books_count = @user.books.where(created_at: 1.week.ago.beginning_of_week(:saturday)..1.week.ago.end_of_week(:friday)).count

    # 今週 / 先週の比率（先週が0のときは0にする）
    @this_last_week_rate = @last_week_books_count == 0 ? "0%" : "#{(@this_week_books_count.to_f / @last_week_books_count * 100).round}%"

  # 過去7日間の投稿数を日ごとに取得
  @weekly_books = 7.times.map do |i|
    date = i.days.ago.to_date
    {
      date: date.strftime("%m/%d"),
      count: @user.books.where(created_at: date.all_day).count
    }
  end.reverse
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def books_on_date
    @user = User.find(params[:id])
    # 指定した日付を受け取る（なければ今日）
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    # 指定した日の投稿数を取得
    @books_count = @user.books.where(created_at: @date.all_day).count
  end

  private

  def user_params
    # name, email_address, password, password_confirmation を許可
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :introduction, :profile_image)
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == Current.session.user
      redirect_to user_path(Current.session.user), alert: "Access error! You can't edit other users."
    end
  end
end
