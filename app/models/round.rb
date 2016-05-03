class Round < ActiveRecord::Base
  belongs_to :phase
  has_many :matches, dependent: :destroy
  has_many :users, through: :matches
  has_many :flippers, through: :matches
end
