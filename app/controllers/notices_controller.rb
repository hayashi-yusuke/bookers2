class NoticesController < ApplicationController
  before_action :set_group

  def new
    # メール作成フォーム用
    @notice = Notice.new
  end

  def create
    # グループメンバー全員にメールを送る
    @group.members.each do |member|
      GroupMailer.notice(@group, member, params[:title], params[:body]).deliver_now
    end
    redirect_to group_path(@group), notice: "送信が完了しました！"
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end