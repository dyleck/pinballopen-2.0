class AddSffPriceToProduct < ActiveRecord::Migration
  def change
    add_column :products, :sff_price, :decimal
  end
end
