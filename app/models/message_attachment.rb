class MessageAttachment < ApplicationRecord
  belongs_to :message_log



  acts_as_mappable :default_units => :kms,
                 :default_formula => :sphere,
                 :lat_column_name => :lat,
                 :lng_column_name => :long
end
