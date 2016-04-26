class Tournament < ActiveRecord::Base
  validates :name, presence: true
  validates :number_of_machines, presence: true, numericality: {:greater_than => 0}
  has_many :flippers
end
