class Road < ApplicationRecord
  belongs_to :area
  has_one :city, through: :area
end
