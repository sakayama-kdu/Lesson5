class LikesController < ApplicationController
  def create
    return redirect_to top_login_form_path unless current_user

    tweet = Tweet.find(params[:tweet_id])
    unless tweet.liked?(current_user)
      tweet.like(current_user)
    end
    redirect_to root_path
  end

  def destroy
    return redirect_to top_login_form_path unless current_user

    tweet = Tweet.find(params[:id])
    if tweet.liked?(current_user)
      tweet.unlike(current_user)
    end
    redirect_to root_path
  end
end
