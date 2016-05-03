class MatchesController < ApplicationController
  before_action :set_tournament

  def new
    @match = Match.new
    @tournament.current_phase.build_scores(@match)
  end

  def create
    @match = Match.create(matches_params)
    if @match
      # polimorphic assignment of match to round
      result = @tournament.current_phase.assign(@match)
      # if returned object is a Match, then score update is required
      if result.is_a?(Match)
        redirect_to edit_match_path(result, tournament_id: @tournament.id)
      # if returned object is a string, then game is started of error is raised
      elsif result.is_a?(String)
        # empty string means game is started
        if result.empty?
          flash[:success] = "Gra rozpoczęta"
          redirect_to matches_path(tournament_id: @tournament.id)
        else
          # all other string means an error so store it in flash and redirect to new form
          flash[:danger] = result
          redirect_to new_match_path(tournament_id: @tournament.id)
        end
      end
    else
      # unspecified error catched
      flash[:danger] = "Wystąpił błąd. Spróbuj jeszcze raz"
      redirect_to new_match_path(tournament_id: @tournament.id)
    end
  end

  def edit
    @match = Match.find_by(id: params[:id])
  end

  def update
    @match = Match.find_by(id: params[:id])
    @match.update_attributes(matches_params)
    flash[:success] = "Wynik zapisany"
    redirect_to matches_path(tournament_id: @tournament.id)
  end

  def destroy
  end

  def show
  end

  def index
  end

  private
    def set_tournament
      @tournament = Tournament.find_by(id: params[:tournament_id])
    end

    def matches_params
      params.require(:match).permit(:flipper_id, scores_attributes: [:id, :user_id, :value])
    end
end
