require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new( first_name: "Zdzislaw", last_name: "Kręcina", email: "zdichu@pzpnrules.com",
                      password: "zibi12", password_confirmation: "zibi12" )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "first_name should be present" do
    @user.first_name = " "
    assert_not @user.valid?
  end

  test "last_name should be present" do
    @user.last_name = " "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "first_name should not be too long" do
    @user.first_name = "a" * 51
    assert_not @user.valid?
  end

  test "last_name should not be too long" do
    @user.last_name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 250 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_emails = %w[user@example.com marcin.dylewski@dylux.net prezes@flippery.org.pl]
    valid_emails.each do |address|
      @user.email = address
      assert @user.valid?, "#{@user.email.inspect} should be a valid address"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_emails = %w[user@example,con user@con dupa_jasiu_at_stasiu.pl user@example.
                        user@ecample..com]
    invalid_emails.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{@user.email.inspect} should be invalid address"
    end
  end

  test "email should be unique" do
    duplicate = @user.dup
    duplicate.email.upcase!
    @user.save
    assert_not duplicate.valid?
  end

  test "email should be downcased before save" do
    @user.email = "user@example.COM"
    @user.save
    assert @user.reload.email == "user@example.com"
  end

  test "password cannot be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be at least 6 chars long" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end