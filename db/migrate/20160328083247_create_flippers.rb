class CreateFlippers < ActiveRecord::Migration
  def change
    create_table :flippers do |t|
      t.string :name
      t.string :short_name
      t.string :translite_url

      t.timestamps null: false
    end
  end
end
