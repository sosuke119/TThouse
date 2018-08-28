require 'rails_helper'

RSpec.describe 'Create user after they pressed Welcome Button .' do


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
        'payload' => 'welcome',
      }
    }
  end

  let :welcome_message_array do 
    [
      { text: '您好，我們是推推房，有什麼我們可以為您服務的嗎？' },
      { text: '您可以查詢特定地點或條件的房地產資訊，或者是依照你的所在位置查詢附近的房產資訊，我們馬上為您服務！' }
    ]
  end


  let :message do 
    Facebook::Messenger::Incoming::Postback.new(message_json)
  end

  let :user do 
    User.where(sender_id:'3',fanpage_id:'4').first_or_create(sender_id:'3',fanpage_id:'4')
  end
 
  subject { BotMessagesController.new(user:user,source: message, source_type:'postback',platform:'facebook') }

  describe '.user' do
    it 'show user that Bot User method created. ' do
      expect(subject.user.sender_id).to eq( message.sender["id"] )
      expect(subject.user.fanpage_id).to eq( message.recipient["id"] )
      expect(User.where(sender_id:subject.user.sender_id).count).to eq(1)
    end
  end

  describe '.reply' do
    it 'reply welcome message array' do
      expect(subject.reply).to eq( welcome_message_array )
    end
  end


end


