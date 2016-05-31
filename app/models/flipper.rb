class Flipper < ActiveRecord::Base
  validates :name, :translite_url, presence: true
  belongs_to :tournament
  has_many :matches

  scope :tournament_order, -> { order(:flipper_number) }
end
