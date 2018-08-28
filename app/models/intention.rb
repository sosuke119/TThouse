class Intention < ApplicationRecord
  has_many :replies, :as => :trigger
  has_many :sessions, :as => :trigger
  has_many :slots, :as => :trigger
end
