class UsersController < ApplicationController
  before_action :redirect_to_login_if_not_logged_in, only: [:update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      redirect_to @user
    else
      render 'new'
    end

  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user
      if !is_update_granted?
        flash[:danger] = "Nie masz uprawnień do edycji tego pola"
        redirect_to current_user
      else
        @user.update_attributes user_params
        redirect_to sff_validations_index_path
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :sff_member, :sff_validated, :admin)
    end

    def is_update_granted?
      if current_user
        parms = user_params
        (parms[:sff_validated] || parms[:admin]) && current_user.admin?
      end
    end
end
