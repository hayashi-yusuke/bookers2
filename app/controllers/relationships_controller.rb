class RelationshipsController < ApplicationController
  before_action :require_authentication

  def create
    user = User.find(params[:user_id])
    Current.user.follow(user)
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    Current.user.unfollow(user)
    redirect_back fallback_location: root_path
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
