class FlippersController < ApplicationController
  before_action :set_flipper, only: [:show, :create, :edit, :update, :destroy]
  def index
    @flippers = Flipper.all
  end

  def show
  end

  def new
    @flipper = Flipper.new
  end

  def create
    @flipper = Flipper.create(flipper_params)
    redirect_to flippers_path
  end

  def edit
  end

  def update
    @flipper = Flipper.find_by(id: params[:id])
    @flipper.update_attributes(flipper_params)
  end

  def destroy
  end

  private
    def set_flipper
      @flipper = Flipper.find_by(id: params[:id])
    end

    def flipper_params
      params.require(:flipper).permit(:name, :short_name, :translite_url)
    end
end
