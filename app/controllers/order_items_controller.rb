class OrderItemsController < ApplicationController
  before_action :set_order

  def create
    # @order_item = @current_order.order_items.build(product_id: params[:product_id], price: params[:price])
    @order_item = @current_order.order_items.build(order_item_params)
    if @order_item && @order_item.save
      respond_to do |format|
        format.js
        format.html { redirect_to new_order_path }
      end
    end
  end

  def destroy
    OrderItem.delete(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private
    def order_item_params
      params.require(:order_item).permit(:size, :price, :product_id)
    end
end
