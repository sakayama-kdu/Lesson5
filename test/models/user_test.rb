require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "password is stored as a BCrypt digest and can be authenticated" do
    user = User.create!(uid: "secure-user", password: "secret123", password_confirmation: "secret123")

    assert_not_equal "secret123", user.password_digest
    assert user.authenticate("secret123")
    assert_not user.authenticate("wrong-password")
  end

  test "uid must be unique" do
    user = User.new(
      uid: users(:one).uid,
      password: "secret123",
      password_confirmation: "secret123"
    )

    assert_not user.valid?
    assert_includes user.errors[:uid], "has already been taken"
  end

  test "destroying a user also destroys their tweets and likes" do
    user = User.create!(uid: "deletable-user", password: "secret123", password_confirmation: "secret123")
    another_user = User.create!(uid: "another-user", password: "secret123", password_confirmation: "secret123")
    tweet = user.tweets.create!(message: "user tweet")
    another_user.likes.create!(tweet: tweet)
    user.likes.create!(tweet: Tweet.create!(message: "another tweet", user: another_user))

    assert_difference("Tweet.count", -1) do
      assert_difference("Like.count", -2) do
        user.destroy
      end
    end
  end
end
