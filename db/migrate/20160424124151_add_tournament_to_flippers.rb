class AddTournamentToFlippers < ActiveRecord::Migration
  def change
    add_reference :flippers, :tournament, index: true, foreign_key: true
  end
end
