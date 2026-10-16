class LikesController < ApplicationController
  def create
    return redirect_to top_login_form_path unless current_user

    tweet = Tweet.find(params[:tweet_id])
    current_user.likes.find_or_create_by(tweet: tweet)
    redirect_to root_path
  end

  def destroy
    return redirect_to top_login_form_path unless current_user

    current_user.likes.find(params[:id]).destroy
    redirect_to root_path
  end
end
