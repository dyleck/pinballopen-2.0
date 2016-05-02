class Phase < ActiveRecord::Base
  belongs_to :tournament
  has_and_belongs_to_many :users

  PHASE_TYPES = ["XOfY", "DoubleKO32", "Final3"]
end
