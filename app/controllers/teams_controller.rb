class TeamsController < ApplicationController
  before_action :set_team, only: [:edit, :update, :show]

  def new
    @team = Team.new(name: "Set your team's name") #TODO t
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      respond_to do |format|
        format.html { redirect_to @team }
        format.js
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @team.update_attributes(team_params)
      respond_to do |format|
        format.js
        format.html { redirect_to @team }
      end
    else
      @team.errors
    end
  end

  def show
  end

  def index
    @teams = Team.all
  end

  private
    def set_team
      @team = Team.find_by id: params[:id]
    end

    def team_params
      p = params.require(:team).permit(:name, :captain_id, :users => [])
      p[:users].map!{|user| User.find_by(id: user)}.compact!
      p
    end
end
