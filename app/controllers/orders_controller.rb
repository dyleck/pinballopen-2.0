class OrdersController < ApplicationController
  before_action :set_order, only: [:new, :update]
  before_action :user_activated?, only: [:new, :create, :update]

  def new
  end

  def create
  end

  def update
    if order_contains?("team") && !order_contains?("main")
      flash[:danger] = t(".team_without_main")
      redirect_to new_order_path
      return
    end
    if @current_order.update_attributes(order_params.merge!({payed: true}))
      if params[:order][:payment_type] == 'paypal'
        paypal_url = @current_order.paypal_url(payment_confirmations_path, user_url(@current_order.user))
        @current_order = session[:order_id] = nil
        redirect_to paypal_url
      else
        @current_order.update_attribute(:payed, true)
        UserMailer.bank_transfer_info(@current_order).deliver_now
        UserMailer.confirm_payment(@current_order).deliver_now
        redirect_to bank_transfer_path(id: @current_order.id)
        session[:order_id] = @current_order = nil
      end
    else
      redirect_to new_order_path
    end
  end

  def destroy
    @order = Order.find_by(id: params[:id])
    @order.destroy
    respond_to do |format|
      format.js
    end
  end

  private
    def order_params
      params.require(:order).permit(:payment_type, :payed)
    end

    def user_activated?
      if !current_user.activated?
        redirect_to root_url
      end
    end

    def order_contains?(item)
      orders = current_user.orders.joins(:products)
                   .where("products.name": item,
                          "orders.payed": true)
                   .map{|order| order.order_items.map{|item| item.product.name}}.flatten
      @current_order.order_items.map{|item| item.product.name}.+(orders).include?(item)
    end
end
