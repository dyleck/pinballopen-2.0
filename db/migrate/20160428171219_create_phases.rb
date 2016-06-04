class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.string :type
      t.references :tournament
      t.boolean :fixed

      t.timestamps null: false
    end
  end
end
