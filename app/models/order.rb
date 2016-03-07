class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items, dependent: :destroy

  PAYMENT_TYPES = [ "Bank Transfer", "PayPal" ]

  validates :user, presence: true
  validates :payment_type, inclusion: PAYMENT_TYPES, allow_nil: true

  def recalc_local_prizes_of_items
    self.update_attribute :locale, I18n.locale
    sff = self.user.sff_validated
    self.order_items.each do |item|
      price = (sff && !item.product.sff_price.nil? && item.product.sff_price > 0) ?
          item.product.sff_price : item.product.price
      price = case I18n.locale
                when :en then (price / 4.4).to_i + 1
                when :pl then price
              end
      item.update_attribute :price, price
    end
  end
end
