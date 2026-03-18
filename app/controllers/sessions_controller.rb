class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    # 名前でユーザーを検索
    if user = User.find_by(name: params[:name])&.authenticate(params[:password])
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def start_new_session_for(user)
  session[:user_id] = user.id
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

   private

  def terminate_session
    session.delete(:user_id)
    @current_user = nil
  end

end
