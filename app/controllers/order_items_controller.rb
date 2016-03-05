class OrderItemsController < ApplicationController
  before_action :set_order

  def create
    @order_item = @current_order.order_items.build(product_id: params[:product_id])
    if @order_item
      if params[:order_item]
        @order_item.update_attributes(order_item_params)
      end
      @order_item.save
    end
    respond_to do |format|
      format.js
      format.html { redirect_to new_order_path }
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
      params.require(:order_item).permit(:size)
    end
end
