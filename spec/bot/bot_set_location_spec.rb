require 'rails_helper'

RSpec.describe " Set user's location after they send location ." do 


  let :message_json do
    {
      'sender' => {
        'id' => '6'
      },
      'recipient' => {
        'id' => '9'
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

  let :message do 
    Facebook::Messenger::Incoming::Message.new(message_json)
  end

  let :user do 
    User.where(sender_id:'3',fanpage_id:'3').first_or_create
  end

  let :set_location_reply_message do 
    [{text: '成功紀錄你的位置！'}]
  end

  let :recommend_properties_reply_message do 
    [{text: '抱歉，沒有符合條件的建案'}]
  end



  describe 'Update Coordinate' do
    before { Slot.migrate }

    it 'User send coordinate to set location' do

      trigger     = Payload.where(name:'set_location').first
      session      = user.sessions.where(trigger_id:trigger.id,trigger_type:'Payload', state:'elicit_slot').first_or_create
      slot         = trigger.slots.first
      session_slot = session.session_slots.where(slot:slot, name:'新座標', required: true, slot_type:'coordinate' ).first_or_create
      subject      = BotMessagesController.new(user:user,source: message, source_type:'message',platform:'facebook')

      coordinate_array = subject.bot_message.coordinate_array
      session_slot     = SessionSlot.find(session_slot.id)
      

      expect(session_slot.value).to eq( coordinate_array.to_json )
      expect(user.lat).to eq( coordinate_array[0] )
      expect(user.long).to eq( coordinate_array[1] )
      expect(subject.reply).to eq( set_location_reply_message )

    end

    it 'User send coordinate to see recommended properties' do

      trigger      = Payload.where(name:'recommend_properties').first
      session      = user.sessions.where(trigger_id:trigger.id,trigger_type:'Payload', state:'elicit_slot').first_or_create
      slot         = trigger.slots.first
      session_slot = session.session_slots.where(slot:slot, name:'目前座標', required: true, slot_type:'coordinate' ).first_or_create
      subject      = BotMessagesController.new(user:user,source: message, source_type:'message',platform:'facebook')

      coordinate_array = subject.bot_message.coordinate_array
      session_slot     = SessionSlot.find(session_slot.id)
      

      expect(session_slot.value).to eq( coordinate_array.to_json )
      expect(user.lat).to eq( coordinate_array[0] )
      expect(user.long).to eq( coordinate_array[1] )
      expect(subject.reply).to eq( recommend_properties_reply_message )

    end




  end


end


