class StaticPagesController < ApplicationController
  def home
  end

  def about
  end

  def contact
  end

  def tournament_main
  end

  def tournament_clasic
  end

  def tournament_team
  end

  def tournament_bop
  end

  def tournament_stern
  end

  def tournament_kids
  end

  def bank_transfer
    @order = Order.find_by(id: params[:id])
  end

  def photos
  end

  def wait_for_sff
  end
end
