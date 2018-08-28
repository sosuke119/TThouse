class BotLuis

  attr_accessor :intention_name, :entities, :entities_value,:entities_hash, :result, :ambiguous_entities, :entities_positions

  def initialize(text)
    @text           = text
    @intention_name = 'None'
    @entities       = []
    @entities_value = []
    @result         = Hash.new

    self.nlp
    
  end

  def nlp
    self.call_api
    self.error_handling
    self.set_intention_name
    self.set_entities
  end

  def call_api
    @result             = Luis.query(@text) 
  end


  def error_handling
    begin 
      if @result.dig(:message).present?
        @intention_name = "None"
        @entities       = []
      end
    rescue
    end
  end

  def set_intention_name

    if intention_filter
      @intention_name = @result.top_scoring_intent.intent 
    else
      @intention_name = "None"
    end
  end

  def set_entities
    return unless @result.try(:entities).present?

    ambiguous_entities_filter
    
    @entities_hash      = Hash.new
    # { name => [value, value] }
    @entities_positions = Hash.new

    @filted_entities.each do |entity_var| 
      if @entities_hash[entity_var.type].blank?
        @entities_hash[entity_var.type] = entity_var.chinese_value
      else
        value_array = @entities_hash[entity_var.type]
        @entities_hash[entity_var.type] = value_array + entity_var.chinese_value
      end
      # 標出entity在原始問句中的位置
      entity        = entity_var.chinese_value
      position      = [entity_var.start_index, entity_var.end_index]
      exist_element = @entities_positions[entity]
      
      if exist_element.blank?
        @entities_positions[entity] = position
      else
        @entities_positions[entity] = exist_element + position unless exist_element == position
      end
    end

    @entities           = @entities_hash.keys
    @entities_value     = @entities_hash.values.flatten

  end
 

private

  def intention_filter
    return false unless @result.try(:top_scoring_intent).try(:intent).present? 
    return false unless @result.try(:intents).count > 0
    return false unless @result.try(:top_scoring_intent).try(:score) > 0.6
    
    true
  end

  def ambiguous_entities_filter

    @filted_entities = @result.entities
    
    ambiguous_property_address
    ambiguous_range

    
  end

  def ambiguous_range
    
    ranges = @filted_entities.select{ |e| e.type == "範圍參考" }

    return unless ranges.size <= 1

    @filted_entities.reject{ |e| e.type == "範圍參考" && !e.chinese_value.include?('不') }

  end

  def ambiguous_property_address  
    
    city  = @filted_entities.select{ |e| e.type == "地址縣市" }[0]
    areas = @filted_entities.select{ |e| e.type == "地址區域" }

    return if areas.blank?

    areas.each do |area|

      if ['路','街','道'].include?(@text[area.end_index+1]) or ['路','街','道'].include?(@text[area.end_index+2]) 
        @filted_entities =  @filted_entities.reject{ |entity| entity.chinese_value == area.chinese_value }
      end
    
      next if city.blank?
      next if city.start_index !=  area.start_index

      if    city.end_index > area.end_index
        @filted_entities =  @filted_entities.reject{ |entity| entity.chinese_value == area.chinese_value }
      elsif city.end_index < area.end_index
        @filted_entities =  @filted_entities.reject{ |entity| entity.chinese_value == city.chinese_value }
      else
        # 這裡做提示
        @filted_entities =  @filted_entities.reject{ |entity| entity.chinese_value == area.chinese_value }
      end

    end
  end


end