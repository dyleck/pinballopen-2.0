class AddNumberOfRoundsToPhase < ActiveRecord::Migration
  def change
    add_column :phases, :number_of_rounds, :integer
  end
end
