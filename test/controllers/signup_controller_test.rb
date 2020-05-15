require 'test_helper'

class SignupControllerTest < ActionDispatch::IntegrationTest

  users = [
    {
    	:user_name => "Test",
    	:password => "P@ssw0rd",
    	:password_confirmation => "P@ssw0rd",
    	:user_email => "test5@yopmail.com",
    	:role => "Admin" # valid case
    },
    {
    	:user_name => "Test",
    	:password => "P@ssw0rd",
    	:password_confirmation => "P@ssw0rd", # Password mismatch
    	:user_email => "test6@yopmail.com",
    	:role => "User"
    },
    {
    	:user_name => "Test",
    	:password => "P@ssw0rd",
    	:password_confirmation => "P@ssw0rd",
    	:user_email => "test6", # Invalid email
    	:role => "User"
    },
    {
      :user_name => "Test",
      :password => "test", # Invalid password
      :password_confirmation => "test",
      :user_email => "test7@yopmail.com",
      :role => "User"
    },
    {
      :user_name => "Test",
      :password => "P@ssw0rd",
      :password_confirmation => "P@ssw0rd",
      :user_email => "test8@yopmail.com",
      :role => "Admin" # Invalid role
    }
  ]

  test "should create user" do
    assert_difference('User.count', 2) do
      users.each do |user|
        post sign_up_url, params: user , as: :json
        assert_response 200
      end
    end
  end

end
