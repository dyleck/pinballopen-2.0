class Flipper < ActiveRecord::Base
  validates :name, :translite_url, presence: true
  belongs_to :tournament
end
