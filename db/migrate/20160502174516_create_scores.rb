class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.references :match, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :value

      t.timestamps null: false
    end
  end
end
