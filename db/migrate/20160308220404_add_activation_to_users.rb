class AddActivationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activation_digest, :string
  end
end
