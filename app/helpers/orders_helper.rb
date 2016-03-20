module OrdersHelper
  def set_order
    if order_id = session[:order_id]
      if !(@current_order = Order.find_by(id: order_id))
        create_empty_order
        remove_empty_orders
      end
    else
      create_empty_order
      remove_empty_orders
    end
    if @current_order.locale != I18n.locale
      @current_order.recalc_local_prizes_of_items
    end
  end

  private
    def create_empty_order
      @current_order = Order.create(user_id: session[:user_id])
      session[:order_id] = @current_order.id
    end

    def remove_empty_orders
      Order.where(payed: [nil, false], user_id: session[:user_id]).where.not(id: session[:order_id]).delete_all
    end
end
