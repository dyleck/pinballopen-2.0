class UserSwitchesController < ApplicationController
  before_action :redirect_to_login_if_not_logged_in
  before_action :redirect_to_root_if_not_admin

  def create
    session[:user_switch_id] = user_switches_params[:user_switch_id]
    redirect_to user_managements_path
  end

  def destroy
    session.delete :user_switch_id
    redirect_to user_managements_path
  end

  private
    def user_switches_params
      params.require(:user_switches).permit(:user_switch_id)
    end
end
