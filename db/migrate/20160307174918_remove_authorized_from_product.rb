class RemoveAuthorizedFromProduct < ActiveRecord::Migration
  def change
    remove_column :products, :authorized, :boolean
  end
end
