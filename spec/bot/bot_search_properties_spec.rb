require 'rails_helper'

RSpec.describe " User search properties." do 


  let :message_json do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '4'
      },
      'timestamp' => 145_776_419_762_7,
      'message' => {
        'is_echo' => false,
        'app_id' => 184_719_329_217_930_000,
        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
        'seq' => 73,
        'text' => @text
      }
    }
  end

  let :test_propertie_template do 
    BotPropertyTemplate.new(test_prop)
  end

  let :message do
    Facebook::Messenger::Incoming::Message.new(message_json)
  end

  let :user do 
    User.where(sender_id:'3',fanpage_id:'4').first_or_create
  end

  let :query_string do 
    BotPropertySlotController.new(@slot_hashes).query_string
  end

  let :bot_message_controller do 
    BotMessagesController.new(user:user,source: message, source_type:'message',platform:'facebook')
  end


  describe 'Query properties' do
    

    before { Slot.migrate}
    before { 
      city = City.where(name:'台北市').first_or_create
      ['大安區','信義區'].each do |area|
        city.areas.where(name:area).first_or_create
      end
      city = City.where(name:'基隆市').first_or_create
      ['信義區'].each do |area|
        city.areas.where(name:area).first_or_create
      end
    }

    it '.condition' do
      
      @text        = '我想找台北市大安區忠孝東路四段三房兩千萬的預售屋'
      @slot_hashes = bot_message_controller.bot_message.slot_hashes

      
      intent       = '查詢地點_房地產'
      entities     = ['地址縣市','地址區域','地址路段','地點類別_建案格局','地點類別_建案型態','金額']
      entities_attr= ['city','area','road','room','status','price','=']

      query_string = BotPropertySlotController.new(@slot_hashes).query_string

      entities_attr.each do |e|
        expect(query_string).to include(e)
      end

      expect(query_string).to eq("city LIKE '%台北市%' AND area LIKE '%大安區%' AND road LIKE '%忠孝東路%' AND status LIKE '%預售屋%' AND price = '2000' AND room LIKE '%三房%'")
    
    end

    it '.condition' do
      
      @text        = '我想找信義區的預售屋'
 
      intent       = '查詢地點_房地產'
      entities     = ['地址縣市','地點類別_建案型態']
      entities_attr= ['city','status']

      trigger = Intention.where(name:intent).first
      slot    = Slot.where(trigger_id:trigger,trigger_type:'Intention',name:'地址縣市').first
      reply   = "請問是哪個 #{slot.name} 呢？"

      expect(bot_message_controller.reply).to eq([reply])

    end

    it '.condition' do
      
      @text        = '我想找大安區的預售屋'
 
      intent       = '查詢地點_房地產'
      entities     = ['地址縣市','地點類別_建案型態']
      entities_attr= ['city','status']

      trigger = Intention.where(name:intent).first
      slot    = Slot.where(trigger_id:trigger,trigger_type:'Intention',name:'地址縣市').first
      reply   = "請問是哪個 #{slot.name} 呢？"

      expect(bot_message_controller.reply).to eq([reply])

    end
    

  end



end


