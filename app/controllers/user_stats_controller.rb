class UserStatsController < ApplicationController
  before_action :redirect_to_login_if_not_logged_in
  before_action :redirect_to_root_if_not_current_user

  def index
    if params[:tournament_id]
      @tournament = Tournament.find_by(id: params[:tournament_id])
      if @tournament.nil?
        @tournament = default_tournament
      end
    else
      @tournament = default_tournament
    end
    @phase = @tournament.current_phase
    @user = User.find_by(params[:user_id])
    if @user.nil?
      redirect_to root_path
    end
  end

  private
    def default_tournament
      Tournament.find_by(name: "Modern")
    end
end
