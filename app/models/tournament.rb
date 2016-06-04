class Tournament < ActiveRecord::Base
  validates :name, presence: true
  validates :number_of_machines, presence: true, numericality: {:greater_than => 0}
  has_many :flippers
  has_many :phases, dependent: :destroy
  accepts_nested_attributes_for :phases, allow_destroy: true

  def current_phase
    self.phases.first # TODO placeholder
  end

  def start
    self.phases.first.users = User.all_that_paid_for_main
    self.phases.first.save
  end

  def started?
    self.phases.first.users.count > 0
  end

  def reset
    self.phases.first.rounds.destroy_all
    self.phases.first.users.clear
    self.phases.first.save
  end
end
