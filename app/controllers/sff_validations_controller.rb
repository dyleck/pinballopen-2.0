class SffValidationsController < ApplicationController
  before_action :redirect_to_login_if_not_logged_in
  before_action :redirect_to_root_if_not_admin

  def index
    @users = User.all
  end

end
