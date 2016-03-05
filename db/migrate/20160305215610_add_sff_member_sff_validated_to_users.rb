class AddSffMemberSffValidatedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sff_member, :boolean, default: false
    add_column :users, :sff_validated, :boolean, default: false
  end
end
