class SessionsController < ApplicationController
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    respond_to do |format|
      if @user and @user.authenticate(params[:session][:password])
            log_in @user
        params[:session][:remember] == "1" ? remember(@user) : forget(@user)
        format.html { redirect_to_from_cookies_or_deault @user }
        format.js
      else
        flash.now[:danger] = t('layouts.login_modal.wrong_password')
        format.js
      end
    end
  end

  def destroy
    user = User.find_by(id: session[:user_id])
    forget user if logged_in?
    log_out
    redirect_to root_path
  end

  private

    def redirect_to_from_cookies_or_default(object)
      if redirect = cookies[:redirect_to]
        cookies.delete :redirect_to
        redirect_to redirect
      else
        redirect_to object
      end
    end
end
