class PhasesUsers < ActiveRecord::Migration
  def change
    create_table :phases_users do |t|
      t.references :phase
      t.references :user
    end
  end
end
