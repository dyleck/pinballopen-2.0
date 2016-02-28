require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users :one
  end

  test "login with wrong credentials should fail" do
    get login_path
    xhr :post, login_path, session: { email: "dupa@jasiu.com", password: "123456789" }
    assert_response :success
    assert_match /#modal-flash.*\.text\(.*\)\.show\(\)/, response.body
  end

  test "login and logout should succeed" do
    get login_path
    xhr :post, login_path, session: { email: @user.email, password: "password" }
    assert_response :success
    assert_match /window\.location\.replace\(\".*#{Regexp.quote(user_path(@user))}\"\).*/, response.body
    assert_equal session[:user_id], @user.id
    delete logout_path
    assert_nil session[:user_id]
    assert_response :redirect
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test "login with remember_me should create cookie" do
    xhr :post, login_path, session: {email: @user.email, password: "password", remember: "1" }
    assert_response :success
    assert_not_nil cookies["remember_token"]
  end

  test "login without remember_me should not create cookie" do
    xhr :post, login_path, session: { email: @user.email, password: "password", remember: "0" }
    assert_response :success
    assert_nil cookies["remember_token"]
  end
end
