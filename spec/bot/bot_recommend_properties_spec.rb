require 'rails_helper'

RSpec.describe " Recommend user the properties near them." do 


  let :message_json do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '4'
      },
      'timestamp' => 145_776_419_762_7,
      'postback' => {
        'payload' => 'recommend_properties',
      }
    }
  end

  let :message do
    Facebook::Messenger::Incoming::Postback.new(message_json)
  end

  let :user do 
    User.first_or_create(sender_id:'3',fanpage_id:'4')
  end

  let :bot_message_controller do 
    BotMessagesController.new(user: user,source: message, source_type:'postback',platform:'facebook')
  end


  let :test_propertie_template do 
    test_prop = Property.where(title:'測試',lat:25.0408625)

    BotPropertyTemplate.new('search_properties', 'facebook',{
        bot_campaign: BotCampaign.new(properties:test_prop, slots_value:[])
      }
    ).template
  end

  let :location_message_json do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '4'
      },
      'timestamp' => 145_776_429_762_4,
      'message' => {
        'is_echo' => true,
        'app_id' => 184_719_329_222_930_001,
        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
        'attachments' => [{
          'type' => 'location',
          'payload' => {
            'coordinates' => {
              'lat' => '25.0408625',
              'long' => '121.554858'
            }
          }
        }]
      }
    }
  end

  let :location_message do 
    Facebook::Messenger::Incoming::Message.new(location_message_json)
  end

  let :set_location_message do 
    BotMessagesController.new(user: user,source: location_message, source_type:'message',platform:'facebook')
  end

 

  describe 'Query properties' do

    before { Slot.migrate }

    it 'user has coordinates' do

      trigger      = Payload.where(name:'set_location').first
      session      = user.sessions.where(trigger_id:trigger.id,trigger_type:'Payload', state:'elicit_slot').first_or_create
      slot         = trigger.slots.first
      session_slot = session.session_slots.where(slot:slot, name:'新座標', required: true, slot_type:'coordinate' ).first_or_create
      subject      = BotMessagesController.new(user:user,source: location_message, source_type:'message',platform:'facebook')


      Property.where(title:'測試',lat:25.0408625,long:121.554858).first_or_create
      Property.where(title:'測試',lat:25.0408625,long:121.554859).first_or_create
      Property.where(title:'測試',lat:25.0408625,long:121.554860).first_or_create

      session = bot_message_controller.bot_message.session

      expect(session.trigger.name).to         eq('recommend_properties')
      expect(session.state).to                eq('ready')
      expect(bot_message_controller.reply).to eq(test_propertie_template)
    end

    it 'user doesnt have coordinates' do

      session = bot_message_controller.bot_message.session
      
      expect(session.trigger.name).to         eq('recommend_properties')
      expect(session.state).to                eq('elicit_slot')
      expect(bot_message_controller.reply).to eq([BotPromptTemplate.current_coordinate])


    end


  end



end


