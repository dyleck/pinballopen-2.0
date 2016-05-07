class ChangeTypeForValueInScores < ActiveRecord::Migration
  def change
    change_table :scores do |t|
      t.change :value, :bigint
    end
  end
end
