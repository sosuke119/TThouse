class BotCampaign

  attr_accessor :banner_properties, :properties_left, :list_properties
  
  def initialize(properties:nil, slots_value:nil)

    @properties   = properties || []
    @slots_value  = slots_value.map{ |value| value.kind_of?(String) }.compact
    @adwords      = Adword.includes(:campaign).where(text: @slots_value)
    @adwords      = @adwords.reject { |adword| adword.campaign.expired_at <= Time.zone.now }


    @banner_properties = []
    @properties_left   = []
    @list_properties   = []

    set_banner_properties
    set_list_properties
  end

  def set_banner_properties
    
  # 台北市
    campaign_properties_ids = @adwords.map{ |adword| adword.property.id }
    

    other_properties        = @properties.reject { |property| 
                                campaign_properties_ids.include?(property.id)
                              }
    other_properties_count  = 5 - campaign_properties_ids.size
    
    other_banner_properties = []
    other_properties.each do |property|
      other_banner_properties << property unless property.url.blank?
      break if other_banner_properties.size == other_properties_count
    end
    
    
    @banner_properties = other_banner_properties
    @properties_left   = other_properties.reject { |property| 
                          other_banner_properties.map(&:id).include?(property.id)
                        }

    insert_campaign_properties
    
  end

  def set_list_properties
    @list_properties = @properties_left.first(4)
    # @properties_left = @properties_left.drop(4)
  end

  def insert_campaign_properties
    # 插入位置
    [ 2 , 5 ].each do |i|
      target_adword = @adwords.find{ |adword| adword.position == i }
      @banner_properties.insert( i-1 ,adword.property ) if target_adword.present? 
    end

    @banner_properties = @banner_properties.compact
  end


end