class Team < ActiveRecord::Base
  belongs_to :user
  has_many :users
  alias_attribute :captain, :user

  validates :user, presence: true
end
