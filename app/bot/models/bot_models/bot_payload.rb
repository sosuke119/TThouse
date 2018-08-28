class BotPayload

  def self.new(hash_or_name)

    if hash_or_name.kind_of?(Hash)
      hash    = hash_or_name
      @params = hash
      @name   = @params[:name]
    else
      name    = hash_or_name
      @params = {name:name}
      @name   = hash_or_name
    end

    return @params.to_json
  end


end
