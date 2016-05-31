class AddFlipperNumberToFlippers < ActiveRecord::Migration
  def change
    add_column :flippers, :flipper_number, :integer
  end
end
