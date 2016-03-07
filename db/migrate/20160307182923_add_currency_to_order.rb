class AddCurrencyToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :locale, :string
  end
end
