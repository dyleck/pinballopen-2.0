class MatchConfirmationsController < ApplicationController
  before_action :redirect_to_login_if_not_logged_in
  before_action :redirect_to_root_if_not_admin
  before_action :set_tournament

  def match_destroy
    @match = Match.find_by(id: params[:id])
  end

  def match_create
    @match = Match.new(match_params)
    if @match.valid?
      if !@tournament.flippers.include?(Flipper.find_by(id: params[:match][:flipper_id]))
        flash[:danger] = "Flipper nie bierze udziału w turnieju"
        redirect_to new_match_path(tournament_id: @tournament)
      elsif flipper = @tournament.current_phase.flipper_if_user_has_unfinished_match?(@match)
        flash[:danger] = "Gracz nie skończył <b>#{flipper.name}</b>"
        redirect_to matches_path(tournament_id: @tournament)
      else
        begin
          if existing_match = @tournament.current_phase.match_if_contains(@match)
            if superadmin?
              redirect_to edit_match_path(existing_match, tournament_id: @tournament.id)
            else
              flash[:danger] = "Użytkownik już zagrał na flipperze"
              redirect_to new_match_path(tournament_id: @tournament)
            end
          end
        rescue
          flash[:danger] = "Użytkownik lub flipper nie znaleziony"
          redirect_to new_match_path(tournament_id: @tournament)
        end
      end
    else
      flash[:danger] = "Podałeś błędne dane"
      redirect_to new_match_path(tournament_id: @tournament)
    end
  end

  def match_edit
    @match = Match.find_by(id: params[:id])
    if @match.nil?
      redirect_to matches_path(tournament_id: @tournament)
    end
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