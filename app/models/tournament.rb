class Tournament < ActiveRecord::Base
  validates :name, presence: true
  validates :number_of_machines, presence: true, numericality: {:greater_than => 0}
  has_many :flippers
  has_many :phases, dependent: :destroy
  accepts_nested_attributes_for :phases, allow_destroy: true

  def current_phase
    self.phases.first # TODO placeholder
  end
end
