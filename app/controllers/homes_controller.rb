class HomesController < ApplicationController
  allow_unauthenticated_access only: [ :top, :about ]

  before_action :resume_session, only: [ :top ]  # ← 追加！

  def top
  end

  def about
  end
end
