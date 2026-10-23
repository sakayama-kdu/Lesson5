require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_index_url
    assert_response :success
  end

  test "should get new" do
    get users_new_url
    assert_response :success
    assert_select "input[name='user[password]'][type='password']"
    assert_select "input[name='user[password_confirmation]'][type='password']"
  end

  test "user index does not expose password digests" do
    user = User.create!(
      uid: "listed-user",
      password: "secret123",
      password_confirmation: "secret123"
    )

    get users_index_url

    assert_response :success
    assert_includes response.body, user.uid
    assert_not_includes response.body, user.password_digest
  end

  test "logged in user can view and update their profile" do
    user = users(:one)
    log_in(user)

    get user_url(user)
    assert_response :success
    assert_select "p", /UID: #{user.uid}/

    get edit_user_url(user)
    assert_response :success
    assert_select "input[name='user[age]']"

    patch user_url(user), params: { user: { age: 30, uid: "changed" } }
    assert_redirected_to user_url(user)
    assert_equal 30, user.reload.age
    assert_equal "MyString", user.uid
  end

  test "profile requires login" do
    get user_url(users(:one))

    assert_redirected_to root_url
  end

  private

  def log_in(user)
    user.update!(password: "secret")
    post top_login_url, params: { uid: user.uid, password: "secret" }
  end
end
