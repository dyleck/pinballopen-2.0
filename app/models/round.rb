class Round < ActiveRecord::Base
  belongs_to :phase
  has_many :matches, dependent: :destroy

end
