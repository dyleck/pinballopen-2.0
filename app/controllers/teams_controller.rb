class TeamsController < ApplicationController
  before_action :set_team, only: [:create, :edit, :update]

  def new
    @team = Team.new(name: "Set your team's name")
  end

  def create
  end

  def edit
  end

  def update
  end

  private
    def set_team
      @team = Team.find_by id: params[:id]
    end
end
