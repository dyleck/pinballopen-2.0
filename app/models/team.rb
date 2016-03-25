class Team < ActiveRecord::Base
  alias_attribute :captain, :user
  has_many :users, dependent: :nullify

  validates :captain_id, presence: true

  MAX = 12
  def members
    [User.find_by(id: [self.captain_id])] + self.users.map{|u| u}
  end
end
