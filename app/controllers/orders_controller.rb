class OrdersController < ApplicationController
  before_action :set_order, only: [:new, :update]
  before_action :user_activated?, only: [:new, :create, :update]

  def new
  end

  def create
  end

  def update
    if @current_order.update_attributes(order_params)
      redirect_to @current_order.paypal_url
      @current_order
    else
      redirect_to new_order_path
    end
  end

  private
    def order_params
      params.require(:order).permit(:payment_type)
    end

    def user_activated?
      if !current_user.activated?
        redirect_to root_url
      end
    end
end
