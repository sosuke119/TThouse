class SlotPrompt < ApplicationRecord
  belongs_to :slot

  scope :required, -> { where(category:'required') }
  scope :hint, -> { where(category:'hint') }


end
