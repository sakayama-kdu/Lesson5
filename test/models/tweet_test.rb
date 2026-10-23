require "test_helper"

class TweetTest < ActiveSupport::TestCase
  test "tweet can be liked, checked, and unliked by a user" do
    user = User.create!(uid: "like-user", password: "secret123", password_confirmation: "secret123")
    tweet = Tweet.create!(message: "test tweet", user: user)

    assert_not tweet.liked?(user)
    assert_difference("Like.count", 1) do
      tweet.like(user)
    end
    assert tweet.liked?(user)

    assert_difference("Like.count", -1) do
      tweet.unlike(user)
    end
    assert_not tweet.liked?(user)
  end

  test "destroying a tweet also destroys its likes" do
    owner = User.create!(uid: "tweet-owner", password: "secret123", password_confirmation: "secret123")
    liker = User.create!(uid: "tweet-liker", password: "secret123", password_confirmation: "secret123")
    tweet = Tweet.create!(message: "liked tweet", user: owner)
    tweet.like(liker)

    assert_difference("Like.count", -1) do
      tweet.destroy
    end
  end
end
