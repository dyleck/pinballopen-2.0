class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      if User.find_by(email: @user.email)
        flash.now[:danger] = t(".exists")
      else
        flash.now[:danger] = t(".cannot")
      end
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
