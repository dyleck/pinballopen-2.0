require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  test "should create session" do
    xhr :post, :create, session: { email: @user.email, password: "password" }
    assert_response :success
  end
end
