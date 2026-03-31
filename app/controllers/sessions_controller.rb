class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    # 名前でユーザーを検索
    if user = User.find_by(name: params[:name])&.authenticate(params[:password])
          Rails.logger.debug "remember_me: #{params[:remember_me]}"  # ← 追加
      start_new_session_for user, remember_me: params[:remember_me] == "1"
      redirect_to after_authentication_url, notice: "Login successfully!"
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to after_logout_url, notice: "Logout successfully!"
  end
end
