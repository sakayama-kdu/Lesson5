class TopController < ApplicationController

  def main
    @tweets = Tweet.includes(:user, :likes).order(created_at: :desc)
  end

  def login_form
  end

  def login

    user = User.find_by(uid: params[:uid])

    if user&.authenticate(params[:password])
      session[:login_uid] = user.uid
      redirect_to root_path
    else
      redirect_to action: :login_form
    end

  end

  def logout
    session.delete(:login_uid)
    redirect_to root_path
  end

end