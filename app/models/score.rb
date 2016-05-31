class Score < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  validates :user, presence: true

end
