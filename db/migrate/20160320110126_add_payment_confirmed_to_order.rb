class AddPaymentConfirmedToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :payment_confirmed, :boolean
  end
end
