class SessionsController < ApplicationController
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    respond_to do |format|
      if @user and @user.authenticate(params[:session][:password])
        log_in(@user)
        format.html { redirect_to @user }
        format.js
      else
        flash.now[:danger] = t('layouts.login_modal.wrong_password')
        format.js
        format.html { render 'new' }
      end
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
