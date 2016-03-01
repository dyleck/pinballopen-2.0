class Product < ActiveRecord::Base
  validates :price, presence: true
  validates :name, presence: true
end
