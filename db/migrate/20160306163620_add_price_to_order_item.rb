class AddPriceToOrderItem < ActiveRecord::Migration
  def change
    add_column :order_items, :price, :decimal
  end
end
