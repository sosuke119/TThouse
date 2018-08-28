class Adword < ApplicationRecord
  belongs_to :campaign
  delegate   :property, :to => :campaign, :allow_nil => true
end
