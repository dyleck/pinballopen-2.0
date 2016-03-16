class UsersController < ApplicationController
  before_action :redirect_to_login_if_not_logged_in, only: [:update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:success] = t("account_activations.edit.link.sent")
      log_in @user
      redirect_to @user
    else
      render 'new'
    end

  end

  def show
    @user = User.find(params[:id])
    if !@user.activated? && flash.empty?
      flash[:warning] = t(".account.not_activated")
    end
  end

  def update
    @user = User.find(params[:id])
    if @user
      if !is_update_granted?
        flash[:danger] = t(".no_permissions")
        redirect_to current_user
      else
        @user.update_attributes user_params
        if (request_source = params[:request_source]) && respond_to?("#{request_source}_path")
          flash[:success] = t(".updated")
          redirect_to send("#{request_source}_path")
        else
          redirect_to @user
        end
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
