class Team < ActiveRecord::Base
  alias_attribute :captain, :user
  has_many :users, dependent: :nullify

  validates :captain_id, presence: true

  MAX = 12
  def members
    [User.find_by(id: [self.captain_id])] + self.users.map{|u| u}
  end

  def Team.count_payed
    Order.joins(:products).where("products.name": "team", "orders.payment_confirmed": true).count
  end
end
