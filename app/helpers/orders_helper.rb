module OrdersHelper
  def set_order
    if order_id = session[:order_id]
      if !(@current_order = Order.find_by(id: order_id))
        @current_order = Order.create(user_id: session[:user_id])
        session[:order_id] = @current_order.id
      end
    else
      @current_order = Order.create(user_id: session[:user_id])
      session[:order_id] = @current_order.id
    end
  end
end
