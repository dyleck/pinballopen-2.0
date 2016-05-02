class Match < ActiveRecord::Base
  belongs_to :round
  belongs_to :flipper
  has_many :scores, dependent: :destroy
  has_many :users, through: :scores
end
