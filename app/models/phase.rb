class Phase < ActiveRecord::Base
  belongs_to :tournament
  has_and_belongs_to_many :users
  has_many :rounds
  has_many :matches, through: :rounds

  PHASE_TYPES = ["XOfY", "DoubleKO32", "Final3"]

  def assign(match)
    raise "assign() is abstract function"
  end
end
