require 'test_helper'

class UserTest < ActiveSupport::TestCase

  has_one :role

  test "empty user" do
    @user = users(:sachin)
    user = User.new(user_name: @user.user_name, user_email: @user.user_email, password_digest: @user.password_digest, role_id: @user.role_id)
    assert_not user.valid?
    assert_not user.save
  end

  test 'valid user' do
      @user = users(:tom)
      user = User.new(user_name: @user.user_name, user_email: @user.user_email, password_digest: @user.password_digest, role_id: @user.role_id)
      assert user.valid?
      assert user.save
    end

    test 'invalid user email' do
      @user = users(:rohit)
      user = User.new(user_name: @user.user_name, user_email: @user.user_email, password_digest: @user.password_digest, role_id: @user.role_id)
      assert_not user.valid?
      assert_not user.save
    end

    test 'invalid user without strong password' do
      @user = users(:harry)
      user = User.new(user_name: @user.user_name, user_email: @user.user_email, password_digest: @user.password_digest, role_id: @user.role_id)
      assert_not user.valid?
      assert_not user.save
    end

    test 'invalid user with wrong role' do
      @user = users(:ashwin)
      user = User.new(user_name: @user.user_name, user_email: @user.user_email, password_digest: @user.password_digest, role_id: @user.role_id)
      assert_not user.valid?
      assert_not user.save
    end

end
