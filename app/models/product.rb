class Product < ActiveRecord::Base
  validates :price, presence: true
  validates :name, presence: true
  has_one :order_item

  def discount_if_sff_local_price(sff)
    price = sff ? self.sff_price : self.price
    case I18n.locale
      when :pl then price
      when :en then (price / 4.4).to_i + 1
    end
  end
end
