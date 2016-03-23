class TeamsController < ApplicationController
  before_action :set_team, only: [:edit, :update, :show]

  def new
    @team = Team.new(name: "Set your team's name")
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      respond_to do |format|
        format.html { redirect_to @team }
      end
    end
  end

  def edit
  end

  def update
    if @team.update_attributes(team_params)
      respond_to do |format|
        format.html { redirect_to @team }
      end
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
      p = params.require(:team).permit(:name, :captain, :users => [])
      p[:users].map!{|user| User.find_by(id: user)}
      p[:captain] = User.find_by(id: p[:captain])
      p
    end
end
