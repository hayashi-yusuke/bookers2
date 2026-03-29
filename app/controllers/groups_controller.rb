class GroupsController < ApplicationController

  before_action :set_group, only: [:show, :edit, :update]
  before_action :check_owner, only: [:edit, :update]

  def index
    # グループ一覧を取得
    @groups = Group.all
  end

  def show
  end

  def new
    # 空のグループオブジェクトを作成
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    # 作成者をオーナーにする
    @group.owner = Current.user
    if @group.save
      redirect_to groups_path, notice: "グループを作成しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "グループを更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def check_owner
    unless @group.owner == Current.user
      redirect_to groups_path, alert: "オーナーのみ編集できます"
    end
  end

  def group_params
    params.require(:group).permit(:name, :introduction)
  end
end