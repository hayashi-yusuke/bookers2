class GroupUsersController < ApplicationController
  before_action :set_group

  def create
    # グループに参加する
    @group.group_users.create(user_id: Current.user.id)
    redirect_to group_path(@group)
  end

  def destroy
    # グループから脱退する
    @group.group_users.find_by(user_id: Current.user.id).destroy
    redirect_to group_path(@group)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end