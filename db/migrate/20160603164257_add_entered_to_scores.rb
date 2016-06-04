class AddEnteredToScores < ActiveRecord::Migration
  def change
    add_column :scores, :entered, :boolean, default: false
  end
end
