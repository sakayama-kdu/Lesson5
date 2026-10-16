class TweetsController < ApplicationController

  def index
    redirect_to root_path
  end

  def new
  end

  def create
    return redirect_to top_login_form_path unless current_user

    current_user.tweets.create(tweet_params)
    redirect_to root_path

  end

  def destroy

    Tweet.find(params[:id]).destroy

    redirect_to tweets_path

  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end

end