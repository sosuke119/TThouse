class City < ApplicationRecord
  has_many :areas
  has_many :roads, through: :areas
end
