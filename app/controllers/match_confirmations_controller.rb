class MatchConfirmationsController < ApplicationController
  before_action :redirect_to_login_if_not_logged_in
  before_action :redirect_to_root_if_not_admin
  before_action :set_tournament

  def match_destroy
    @match = Match.find_by(id: params[:id])
  end

  def match_create
    @match = Match.new(match_params)
    if existing_match = @tournament.current_phase.match_if_contains(@match)
      redirect_to edit_match_path(existing_match, tournament_id: @tournament.id)
    end
  end

  def match_edit
    @match = Match.find_by(id: params[:id])
    @new_scores = @tournament.current_phase.update_scores(@match, params)
  end

  private
    def set_tournament
      @tournament = Tournament.find_by(id: params[:tournament_id])
    end

    def match_params
      params.require(:match).permit(:flipper_id, scores_attributes: [:id, :user_id, :value])
    end
end