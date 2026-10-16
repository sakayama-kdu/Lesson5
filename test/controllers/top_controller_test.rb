require "test_helper"

class TopControllerTest < ActionDispatch::IntegrationTest
  test "guest can see tweets but not posting or like controls" do
    tweet = Tweet.create!(message: "public tweet", user: users(:one))

    get root_url

    assert_response :success
    assert_includes response.body, tweet.message
    assert_select "textarea[name='tweet[message]']", count: 0
    assert_select "form[action*='/likes']", count: 0

    get tweets_url
    assert_redirected_to root_url
  end

  test "registration stores a BCrypt digest and rejects duplicate uids" do
    assert_difference("User.count", 1) do
      post users_url, params: { user: { uid: "new-user", password: "secret123" } }
    end

    user = User.find_by!(uid: "new-user")
    assert_not_equal "secret123", user.password_digest
    assert_redirected_to root_url

    assert_no_difference("User.count") do
      post users_url, params: { user: { uid: "new-user", password: "secret456" } }
    end
    assert_response :success
  end

  test "registered user can log in, post, like, and remove a like" do
    user = User.create!(uid: "workflow-user", password: "secret123")
    other_user = User.create!(uid: "tweet-owner", password: "secret123")
    tweet = Tweet.create!(message: "another user's tweet", user: other_user)

    post top_login_url, params: { uid: user.uid, password: "secret123" }
    assert_redirected_to root_url

    get root_url
    assert_select "textarea[name='tweet[message]']"
    assert_select "form[action*='/likes']"

    assert_difference("Tweet.count", 1) do
      post tweets_url, params: { tweet: { message: "my new tweet" } }
    end
    assert_equal user, Tweet.order(:id).last.user

    assert_difference("Like.count", 1) do
      post likes_url, params: { tweet_id: tweet.id }
    end
    like = user.likes.find_by!(tweet: tweet)

    assert_difference("Like.count", -1) do
      delete like_url(like)
    end
  end

  test "login rejects an incorrect password" do
    user = User.create!(uid: "login-user", password: "secret123")

    post top_login_url, params: { uid: user.uid, password: "incorrect" }

    assert_redirected_to top_login_form_url
    assert_nil session[:login_uid]
  end
end
