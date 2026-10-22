class UsersController < ApplicationController
  before_action :require_login, only: %i[show edit update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(profile_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
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

  def require_login
    redirect_to root_path unless current_user
  end

  def profile_params
    params.require(:user).permit(:age)
  end

  def user_params
    params.require(:user).permit(:uid, :password, :password_confirmation)
  end

end