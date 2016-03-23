class Team < ActiveRecord::Base
  belongs_to :user
  alias_attribute :captain, :user
  has_many :users

  validates :captain, presence: true

  after_save :set_captain_team_id

  def members
    [self.captain] + (self.users - [self.captain])
  end

  private
    def set_captain_team_id
      self.captain.update_attributes(team: self)
    end
end
