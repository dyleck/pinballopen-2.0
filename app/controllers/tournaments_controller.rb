class TournamentsController < ApplicationController
  before_action :redirect_to_login_if_not_logged_in, except: [:standings]
  before_action :redirect_to_root_if_not_admin, except: [:standings]
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :standings]

  def show
  end

  def new
    @tournament = Tournament.new
    @tournament.phases.build
  end

  def create
    @tournament = Tournament.create(tournament_params)
    if @tournament.errors.any?
      render 'new'
    else
      @tournament.phases.first.users << User.all_that_paid_for_main # TODO: move to start of tournament action
      redirect_to tournaments_path
    end
  end

  def edit
  end

  def update
    @tournament = Tournament.find_by(id: params[:id])
    @tournament.update_attributes(tournament_params)
    if @tournament.errors.any?
      render 'edit'
    else
      redirect_to tournaments_path
    end
  end

  def destroy
    @tournament.destroy
    redirect_to tournaments_path
  end

  def index
    @tournaments = Tournament.all
  end

  def standings
    @projector = !params[:projector].nil?
    respond_to do |format|
      format.js {}
      format.html do
        # render layout: false if @projector
      end
    end
  end

  private
    def tournament_params
      p = params.require(:tournament).permit(:name, :number_of_machines, flippers: [],
                                             phases_attributes: [:type,
                                                                 :id,
                                                                 :_destroy,
                                                                 :fixed,
                                                                 :number_of_rounds ])
      number = p[:number_of_machines].to_i
      if p[:flippers]
        p[:flippers] = p[:flippers].map{|id| Flipper.find_by(id: id)}[0, number].compact
      end
      p
    end

    def set_tournament
      @tournament = Tournament.find_by(id: params[:id])
    end
end
