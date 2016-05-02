class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :round, index: true, foreign_key: true
      t.references :flipper, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
