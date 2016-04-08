class TeamsController < ApplicationController
  before_action :set_team, only: [:edit, :update, :show]

  def new
    @team = Team.new(name: t('.default_name'))
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    current_user.update_attribute :team, nil
    if users_already_assigned?
      respond_to do |format|
        format.js
      end
    else
      @team = Team.new(team_params)
      if @team.save
        respond_to do |format|
          format.html { redirect_to @team }
          format.js
        end
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
    if users_already_assigned?
      # Users taken
      respond_to do |format|
        format.js
      end
    else
      if @team.update_attributes(team_params)
        respond_to do |format|
          format.js
          format.html { redirect_to @team }
        end
      else
        @team.errors #TODO errors handling
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
      p = params.require(:team).permit(:name, :captain_id, :users => [])
      p[:users].map!{|user| User.find_by(id: user)}.compact!
      p
    end

    def users_already_assigned?
      @message = []
      User.where(id: params[:team][:users]).compact.each do |user|
        next if user.team.nil?
        if user.team.id.to_s != params[:id]
          @message << "#{user.full_name} #{t("teams.user_in_other_team")}"
        end
      end
      if @message.empty?
        @message = nil
      else
        @message
      end
    end
end
