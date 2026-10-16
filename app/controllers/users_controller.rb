class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)

    if user.save

      # 自動ログイン
      session[:login_uid] = user.uid

      # Topページへ移動
      redirect_to root_path

    else
      @user = user
      render "new"

    end

  end

  def destroy

    user = User.find(params[:id])

    user.destroy

    redirect_to users_path

  end

  private

  def user_params
    params.require(:user).permit(:uid, :password, :password_confirmation)
  end

end