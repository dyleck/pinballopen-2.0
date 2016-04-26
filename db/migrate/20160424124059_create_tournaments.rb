class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :number_of_machines

      t.timestamps null: false
    end
  end
end
