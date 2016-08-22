class RedirectionController < ApplicationController
  def login_user_type
    if user_signed_in? or owner_signed_in? then
      flash[:already] = "이미 로그인하셨습니다."
      redirect_to root_path
    end
  end
end
