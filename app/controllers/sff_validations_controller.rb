class SffValidationsController < ApplicationController
  def index
    @users = User.all
  end

end
