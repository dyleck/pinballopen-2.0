class UserManagementsController < ApplicationController
  def index
    @users = User.all
  end
end
