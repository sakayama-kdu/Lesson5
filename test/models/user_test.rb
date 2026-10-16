require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "password is stored as a BCrypt digest and can be authenticated" do
    user = User.create!(uid: "secure-user", password: "secret123")

    assert_not_equal "secret123", user.password_digest
    assert user.authenticate("secret123")
    assert_not user.authenticate("wrong-password")
  end

  test "uid must be unique" do
    user = User.new(uid: users(:one).uid, password: "secret123")

    assert_not user.valid?
    assert_includes user.errors[:uid], "has already been taken"
  end
end
