class RemoveUserIdFromTables < ActiveRecord::Migration
  def change
    remove_reference :teams, :user
  end
end
