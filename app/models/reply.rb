class Reply < ApplicationRecord
  
  belongs_to :trigger, :polymorphic => true


  def self.unknown
    puts 'Reply => unknown'
    unknown_replies = Intention.find_by(name:'None').replies
    unknown_replies.first 

    "抱歉，我現在還看不懂你的問題"
  end

  def self.migrate
    schema = self.schema
    
    schema[:intent].each do |i|
      Intention.where(name:i).first_or_create
    end

    schema[:payload].each do |i|
      Intention.where(name:i).first_or_create
    end

    schema[:replies].each do |sh|
      trigger = nil
      case sh[:trigger_type]
      when 'Intention'
        trigger = Intention.where(name:sh[:trigger_name]).first_or_create
      when 'Payload'
        trigger = Payload.where(name:sh[:trigger_name]).first_or_create
      end
      sh[:replies].each do |slot|
        Slot.where(
          trigger_type: sh[:trigger_type], 
          trigger_id:   trigger.id,
          name:         slot[:name],
          required:     slot[:required],
          slot_type:    slot[:slot_type]
          ).first_or_create
      end
    end


  end


  def self.schema

    payload = [
      'recommend_properties',
      'set_location',
    ]

    replies = [
      {
        trigger_name: "查詢地點_房地產",
        trigger_type: 'Intention',
        replies: [
          {:name=>"地址縣市",         :required=>true, :slot_type=>"text"},
        ]
      }
    ]

    {
      intent: intent,
      payload: payload,
      replies: replies
    }
  end

end
