  class Property < ApplicationRecord
  
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :long

  has_many :campaigns
  has_many :adwords, :through => :campaigns


  def self.order_by_distance(coordinate_array, properties)
    if coordinate_array.present? && properties.present?
      properties.by_distance(:origin => coordinate_array)
    end
  end

  
  def self.import_properties_two(file)
    spreadsheet = Roo::Spreadsheet.open(file)
    
    (3..spreadsheet.last_row).each do |i|
      post_id       = spreadsheet.cell(i,'A').gsub!(/\s|"|'/, '').to_i
      title         = spreadsheet.cell(i,'B').gsub!(/\s|"|'/, '').strip
      state         = spreadsheet.cell(i,'C').gsub!(/\s|"|'/, '').strip
      city          = spreadsheet.cell(i,'D').gsub!(/\s|"|'/, '').strip
      area          = spreadsheet.cell(i,'E').gsub!(/\s|"|'/, '').strip
      zip           = spreadsheet.cell(i,'F').gsub!(/\s|"|'/, '').to_i
      price         = spreadsheet.cell(i,'G').gsub!(/\s|"|'/, '').to_f
      status        = spreadsheet.cell(i,'H').gsub!(/\s|"|'/, '').strip
      property_type = spreadsheet.cell(i,'I').gsub!(/\s|"|'/, '').strip
      building_type = spreadsheet.cell(i,'J').gsub!(/\s|"|'/, '').strip
      size_min      = spreadsheet.cell(i,'K').gsub!(/\s|"|'/, '').to_f
      garage        = spreadsheet.cell(i,'L').gsub!(/\s|"|'/, '').to_i
      garage_price  = spreadsheet.cell(i,'M').gsub!(/\s|"|'/, '').to_f

      next unless post_id.present? and title.present?

      hash = {  
        state:         state,
        city:          city,
        area:          area,
        zip:           zip,
        price:         price,
        status:        status,
        property_type: property_type,
        building_type: building_type,
        size_min:      size_min,
        garage:        garage,
        garage_price:  garage_price
      }

      property = Property.where(title:title).first
      property.update!(hash)  if property.present?

    end
  end

  # def self.import(file)
  #   spreadsheet = Roo::Spreadsheet.open(file)
    
  #   (3..spreadsheet.last_row).each do |i|
  #     sid          = spreadsheet.cell(i,'A').gsub!(/\s|"|'/, '').to_i
  #     post_id      = spreadsheet.cell(i,'B').gsub!(/\s|"|'/, '').to_i
  #     lat          = spreadsheet.cell(i,'C').gsub!(/\s|"|'/, '').to_d
  #     long         = spreadsheet.cell(i,'D').gsub!(/\s|"|'/, '').to_d
  #     title        = spreadsheet.cell(i,'E').gsub!(/\s|"|'/, '').strip
  #     company      = spreadsheet.cell(i,'F').gsub!(/\s|"|'/, '').strip
  #     address      = spreadsheet.cell(i,'G').gsub!(/\s|"|'/, '').strip
  #     sec_price    = spreadsheet.cell(i,'H').gsub!(/\s|"|'/, '').to_i
  #     images_path  = spreadsheet.cell(i,'I').gsub!(/'/, '').try(:strip)
  #     modify_time  = spreadsheet.cell(i,'J').gsub!(/\s|"|'/, '').strip

  #     next unless title.present? and address.present?

  #     hash = {
  #       sid:          sid,
  #       lat:          lat,
  #       long:         long,
  #       title:        title,
  #       company:      company,
  #       address:      address,
  #       sec_price:    sec_price,
  #       images_path:  images_path,
  #       modify_time:  modify_time,
  #     }

  #     property = Property.where(hash).first_or_create(hash)
  #   end
  # end

  def self.import(file)
    require 'csv'
    
    CSV.foreach(file.path, headers: true) do |row|

      property_hash = row.to_hash.select{ |key, value| Property.column_names.include?(key.to_s) }.compact

      property_hash = property_hash.select{ |key, value| ![:id, :created_at, :updated_at].include?(key.to_sym) }.compact

      property_hash = property_hash.update(property_hash) { |key, value| value.include?(' - ') ? nil : value }.compact

      Property.where(property_hash).first_or_create!
        
    end
  end

  def self.update_cordinate
    
    Property.where(long:nil).each do |property|
      
      options = { query: { address: property.address } }

      result = HTTParty.get( "http://posland.g0v.io",options)

      begin
        cordinate = result.parsed_response["results"][0]["geometry"]["location"]
        property.update(
          lat:  cordinate["lat"],
          long: cordinate["lng"]
        )
      rescue
      end

      
    end

  end

end
