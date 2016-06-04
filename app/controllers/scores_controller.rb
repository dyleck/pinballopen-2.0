class ScoresController < ApplicationController
  def update
    @score = Score.find_by(id: params[:id])
    @score.update_attributes(entered: true)
    @tournament = Tournament.find_by(id: params[:tournament_id])
    redirect_to matches_path(tournament_id: @tournament)
  end
end
