class ChatroomSetting

  include HTTParty

  def initialize( domain: ENV['ROOT_URL'], access_token: ENV['ACCESS_TOKEN'])
    @domain       = domain
    @access_token = access_token
    
    
  end

  def update
    HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messenger_profile?access_token=#{@access_token}", 
      headers: { 'Content-Type' => 'application/json' },
      body: @body
    )
  end

  def delete(fields_array)
    # field_name: greeting , get_started, persistent_menu, 
    HTTParty.delete(
      "https://graph.facebook.com/v2.6/me/messenger_profile?access_token=#{@access_token}", 
      headers: { 'Content-Type' => 'application/json' },
      body: {
        "fields": fields_array
      }
    )
  end

  def setup_and_renew_all_settings
    self.whitelist_root_domain
    self.set_greeting
    self.set_start_button
    self.set_menu
  end


  def whitelist_root_domain
    @body = {
      "whitelisted_domains": [ @domain ]
    }
    self.update
  end


  # 開始使用的歡迎語
  def set_greeting

    @body = {
      "greeting": [
        {
          locale: 'default',
          text: '歡迎語'
        }.to_json
      ]
    }
    self.update
  end

  def set_start_button
    

    @body = {
      "get_started": {
        payload: BotPayload.new('welcome')
      }.to_json
    }

     self.update
  end

  # 漢堡 Menu
  def set_menu

    @body = {
      "persistent_menu":[
        {
          locale:"default",
          call_to_actions:[
            {
              title: "更改我的位置",
              type:  "postback",
              payload:BotPayload.new('set_location')
            },
            {
              title: "找房子",
              type:  "postback",
              payload:BotPayload.new('recommend_properties')
            },
            {
              title: "關於推推房",
              type:  "nested",
              call_to_actions:[
                {
                  type:'web_url',
                  title:"官方網站",
                  url: ENV['TBOT_HOME_PAGE'] ,
                  webview_height_ratio:"tall"
                }
              ]
            }
          ]
        }
      ].to_json
    }

    self.update
  end

end