require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid user should not get created" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { first_name: "Test1",
                               last_name: "Test1",
                               email: "dupa@jasiu",
                               password: "123",
                               password_confirmation: "123" }

    end
    assert_template 'users/new'
  end

  test "valid user should get created" do
    get signup_path
    assert_difference 'User.count' do
      post_via_redirect users_path, user: { first_name: "Marcin",
                                            last_name: "Dylewski",
                                            email: "marcin.dylewski@dylux.net",
                                            password: "Testowe1",
                                            password_confirmation: "Testowe1" }
    end
    assert_template 'users/show'
  end
end
