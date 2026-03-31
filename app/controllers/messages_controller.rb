class MessagesController < ApplicationController
  before_action :set_other_user
  before_action :check_mutual_follow


  def index
    # 自分と相手のメッセージ両方向で取得（時系列順）
    @messages = Message.where(
      "(sender_id = :me AND receiver_id = :other) OR (sender_id = :other AND receiver_id = :me)",
      me: Current.user.id, other: @other_user.id
    ).order(:created_at)

    # 新規メッセージ用の空オブジェクト
    @message = Message.new

    # サイドバー用：過去にDMしたユーザー一覧
    partner_ids = Message.where("sender_id = :me", me: Current.user.id).pluck(:receiver_id) +
                  Message.where("receiver_id = :me", me: Current.user.id).pluck(:sender_id)
    @partners = User.where(id: partner_ids.uniq)
  end

  def create
    # フォームから受け取った内容でメッセージを作成
    @message = Message.new(message_params)
    @message.sender = Current.user
    @message.receiver = @other_user

    if @message.save
      # 保存成功→DM画面に画面にリダイレクト
      redirect_to user_messages_path(@other_user)
    else
      # 保存失敗→エラーを表示しながら同じ画面を再表示
      @messages = Message.where(
        "(sender_id = :me AND receiver_id = :other) OR (sender_id = :other AND receiver_id = :me)",
        me: Current.user.id, other: @other_user.id
      ).order(:created_at)
      partner_ids = Message.where(sender_id: Current.user.id).pluck(:receiver_id) +
                    Message.where(receiver_id: Current.user.id).pluck(:sender_id)
      @partners = User.where(id: partner_ids.uniq)
      render :index, status: :unprocessable_entity
    end
  end

  private
  # URLの :user_id から相手ユーザーを取得するメソッド
  def set_other_user
    @other_user = User.find(params[:user_id])
  end

  # フォームから受け取っていい項目を content だけに制限する
  def message_params
    params.require(:message).permit(:content)
  end

  # 相互フォローか確認するメソッド
  def check_mutual_follow
    # 自分が相手をフォローしているか？
    following = Current.user.following?(@other_user)
    # 相手が自分をフォローしているか？
    followed  = Current.user.followers.include?(@other_user)

    # どちらかがfalseなら弾く
    unless following && followed
      redirect_to root_path, alert: "相互フォローの相手とのみDMできます"
    end
  end
end
