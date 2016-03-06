class OrdersController < ApplicationController
  before_action :set_order, only: [:new, :update]

  def new
  end

  def create
  end

  def update
    if @current_order.update_attributes(order_params)
      # Proceed with checkout
      @current_order
    else
      redirect_to new_order_path
    end
  end

  private
    def order_params
      params.require(:order).permit(:payment_type)
    end
end
