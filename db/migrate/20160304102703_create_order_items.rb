class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :product, index: true, foreign_key: true
      t.references :order, foreign_key: true
      t.decimal :quantity

      t.timestamps null: false
    end
  end
end
