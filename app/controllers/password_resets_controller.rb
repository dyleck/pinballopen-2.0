class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:password_reset][:email])
    if user
      user.create_reset_digest
      UserMailer.password_reset(user).deliver_now
      redirect_to root_url
    else
      flash[:danger] = t('.email_not_there')
      render 'new'
    end
  end

  def edit
    @user = User.find_by(email: params[:email])
    if !@user || !@user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
    @user.reset_token = params[:id]
  end

  def update
    user = User.find_by(email: params[:email])
    if !user && !user.authenticated?(:reset, params[:reset_token])
      redirect_with_error user
    else
      if params[:password_reset][:password] == params[:password_reset][:password_confirmation]
        if user.update(params.require(:password_reset).permit(:password, :password_confirmation))
          user.update_attribute :reset_digest, nil
          log_in user
          flash[:success] = t(".password_changed")
          redirect_to user
        else
          redirect_with_error user
        end
      end
    end
  end

  private
    def redirect_with_error(user)
      message = ""
      user.errors.messages.each do |key, value|
        message = t("users.new.signup.#{key.to_s}") + " #{value.sum {|msg| msg + " "}}"
      end
      flash[:danger] = message
      redirect_to edit_password_reset_path(params[:reset_token], locale: I18n.locale, email: user.email)
    end
end
