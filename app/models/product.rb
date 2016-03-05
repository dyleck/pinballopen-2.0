class Product < ActiveRecord::Base
  validates :price, presence: true
  validates :name, presence: true
  has_one :order_item
end
