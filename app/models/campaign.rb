class Campaign < ApplicationRecord
  belongs_to :property
  has_many :adwords
end
