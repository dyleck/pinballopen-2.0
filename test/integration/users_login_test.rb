require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users :one
  end

  test "login with wrong credentials should fail" do
    get login_path
    post login_path, session: { email: "dupa@jasiu.com", password: "123456789" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login and logout should be successful" do
    get login_path
    post login_path, session: { email: @user.email, password: "password" }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", "/pl" + login_path, count: 0
    assert_select "a[href=?]", "/pl" + logout_path, count: 1
    assert_select "a[href=?]", "/pl" + user_path(@user)
    delete logout_path
    assert_nil session[:user_id]
    assert_response :redirect
    follow_redirect!
    assert_template 'static_pages/home'
  end
end
