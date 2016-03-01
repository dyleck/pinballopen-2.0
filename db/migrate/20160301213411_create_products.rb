class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.boolean :authorized, default: false

      t.timestamps null: false
    end
  end
end
