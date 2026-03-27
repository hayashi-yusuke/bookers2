class MessagesController < ApplicationController
  before_action :set_other_user

  def index
    #自分と相手のメッセージ両方向で取得（時系列順）
    @messages = Message.where(
      "(sender_id = :me AND receiver_id = :other) OR (sender_id = :other AND receiver_id = me)",
      me: Current.user.id, other: @other_user.id
    ).order(:created_at)

    #新規メッセージ用の空オブジェクト
    @messages = Message.new

    #サイドバー用：過去にDMしたユーザー一覧
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
  def massage_params
    params.require(:massage).permit(:content)
  end
end
