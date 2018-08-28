class SessionSlot < ApplicationRecord
  belongs_to :session
  belongs_to :slot


  scope :required_but_empty, -> { where("value IN ('0','') OR value IS NULL").where(required: true).order(:priority) }
  scope :filled, -> { where.not("value IN ('0','') OR value IS NULL").order(:priority) }

  attr_accessor :position

end
