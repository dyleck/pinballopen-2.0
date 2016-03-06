class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items, dependent: :destroy

  PAYMENT_TYPES = [ "Bank Transfer", "PayPal" ]

  validates :user, presence: true
  validates :payment_type, inclusion: PAYMENT_TYPES, allow_nil: true
end
