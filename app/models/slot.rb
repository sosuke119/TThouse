class Slot < ApplicationRecord
  belongs_to :trigger, :polymorphic => true
  
  has_many :session_slots, dependent: :destroy
  has_many :slot_prompts,  dependent: :destroy

  def self.migrate
    schema = self.schema
    
    schema[:intent].each do |i|
      Intention.where(name:i).first_or_create
    end

    schema[:payload].each do |i|
      Intention.where(name:i).first_or_create
    end

    schema[:slots].each do |sh|
      trigger = nil
      case sh[:trigger_type]
      when 'Intention'
        trigger = Intention.where(name:sh[:trigger_name]).first_or_create
      when 'Payload'
        trigger = Payload.where(name:sh[:trigger_name]).first_or_create
      end

      sh[:slots].each_with_index do |slot,index|
        
        s = Slot.where(
          trigger_type: sh[:trigger_type], 
          trigger_id:   trigger.id,
          name:         slot[:name],
          ).first_or_create
        
        s.update(
          priority:     index+1,
          required:     slot[:required],
          slot_type:    slot[:slot_type],
          is_hint:      slot[:is_hint] || false,
        )

        if slot[:slot_prompt].present?
          s.slot_prompts.where(
            text:     slot[:slot_prompt],
            category: s.is_hint ? 'hint' : 'required'
          ).first_or_create
        end

      end
    end


  end


  def self.schema

    intent = [
      '查詢地點_房地產',
      '傳送位置',
      '查詢價格',
    ]

    payload = [
      'recommend_properties',
      'set_location',
    ]

    slots = [
      {
        trigger_name: "查詢地點_房地產",
        trigger_type: 'Intention',
        slots: [
          {:name=>"地址縣市",         :required=>true,  :slot_type=>"text", is_hint: false, slot_prompt:'請問您要查詢的房產位於哪個縣市？ 請直接告訴我或點擊按鈕：'},
          {:name=>"地址區域",         :required=>true,  :slot_type=>"text", is_hint: true,  slot_prompt:'請問您有指定的鄉鎮市區嗎？ 請直接告訴我或點擊按鈕：'},
          {:name=>"地址路段",         :required=>true,  :slot_type=>"text", is_hint: true,  slot_prompt:'請問您有指定的路段嗎？ 請直接告訴我或點擊按鈕：'},
          {:name=>"地址國家",         :required=>false, :slot_type=>"text"},
          {:name=>"地址參考",         :required=>false, :slot_type=>"text"},
          {:name=>"地點名稱",         :required=>false, :slot_type=>"text"},
          {:name=>"目前座標",         :required=>false, :slot_type=>"coordinate"},
          {:name=>"金額",            :required=>false, :slot_type=>"text"},
          {:name=>"範圍參考",         :required=>false, :slot_type=>"text"},
          {:name=>"價格",            :required=>false, :slot_type=>"text"},
          {:name=>"地點類別_建案型態", :required=>false, :slot_type=>"text"},
          {:name=>"地點類別_建案特色", :required=>false, :slot_type=>"text"},
          {:name=>"地點類別_建案公設比",:required=>false, :slot_type=>"text"},
          {:name=>"地點類別_建案格局",  :required=>false, :slot_type=>"text"},
          {:name=>"地點類別_建商名稱",  :required=>false, :slot_type=>"text"},
          {:name=>"坪數",             :required=>false, :slot_type=>"text"},
          
          
        ]
      },
      {
        trigger_name: "查詢價格",
        trigger_type: 'Intention',
        slots: [
          {:name=>"地址縣市",         :required=>true, :slot_type=>"text", is_hint: false, slot_prompt:'請問您要查詢的房產位於哪個縣市？ 請直接告訴我或點擊按鈕：'},
          {:name=>"地址區域",         :required=>true, :slot_type=>"text", is_hint: true,  slot_prompt:'請問您有指定的鄉鎮市區嗎？ 請直接告訴我或點擊按鈕：'},
          {:name=>"地址路段",         :required=>true, :slot_type=>"text", is_hint: true,  slot_prompt:'請問您有指定的路段嗎？ 請直接告訴我或點擊按鈕：'},
          {:name=>"地址國家",         :required=>false, :slot_type=>"text"},
          {:name=>"地址參考",         :required=>false, :slot_type=>"text"},
          {:name=>"地點名稱",         :required=>false, :slot_type=>"text"},
          {:name=>"目前座標",         :required=>false, :slot_type=>"coordinate"},
          {:name=>"金額",            :required=>false, :slot_type=>"text"},
          {:name=>"範圍參考",         :required=>false, :slot_type=>"text"},
          {:name=>"價格",            :required=>false, :slot_type=>"text"},
          {:name=>"地點類別_建案型態", :required=>false, :slot_type=>"text"},
          {:name=>"地點類別_建案特色", :required=>false, :slot_type=>"text"},
          {:name=>"地點類別_建案公設比",:required=>false, :slot_type=>"text"},
          {:name=>"地點類別_建案格局",  :required=>false, :slot_type=>"text"},
          {:name=>"地點類別_建商名稱",  :required=>false, :slot_type=>"text"},
          {:name=>"坪數",             :required=>false, :slot_type=>"text"},
          
        ]
      },
      {
        trigger_name: "查詢地點",
        trigger_type: 'Intention',
        slots: [
          {:name=>"地址縣市",         :required=>true,  :slot_type=>"text", is_hint: false, slot_prompt:'請問您要查詢的地點位於哪個縣市？ 請直接輸入或點擊按鈕：'},
          {:name=>"地址區域",         :required=>true,  :slot_type=>"text", is_hint: true,  slot_prompt:'請問您有指定的鄉鎮市區嗎？ 請直接輸入或點擊按鈕：'},
          {:name=>"地址路段",         :required=>true,  :slot_type=>"text", is_hint: true,  slot_prompt:'請問您有指定的路段嗎？ 請直接輸入或點擊按鈕：'},
          {:name=>"地點類別",         :required=>true, :slot_type=>"text", is_hint: false,  slot_prompt:'請問您要查詢的地點是哪種呢？ 請直接輸入或點擊按鈕：'},
          {:name=>"地址國家",         :required=>false, :slot_type=>"text"},
          {:name=>"地址參考",         :required=>false, :slot_type=>"text"},
          {:name=>"地點名稱",         :required=>false, :slot_type=>"text"},
          {:name=>"目前座標",         :required=>false, :slot_type=>"coordinate"},
          {:name=>"金額",            :required=>false, :slot_type=>"text"},
          {:name=>"範圍參考",         :required=>false, :slot_type=>"text"},
          {:name=>"價格",            :required=>false, :slot_type=>"text"},
          
        ]
      },
      {
        trigger_name: '傳送位置',
        trigger_type: 'Intention',
        slots: [
          {:name=>"新座標", :required=>true, :slot_type=>"coordinate"},
        ]
      },
      {
        trigger_name: 'set_location',
        trigger_type: 'Payload',
        slots: [
          {:name=>"新座標", :required=>true, :slot_type=>"coordinate"},
        ]
      },
      {
        trigger_name: 'recommend_properties',
        trigger_type: 'Payload',
        slots: [
          {:name=>"目前座標", :required=>true, :slot_type=>"coordinate"},
        ]
      },
      {
        trigger_name: 'search_near_by_poi',
        trigger_type: 'Payload',
        slots: [
          {:name=>"目前座標", :required=>true, :slot_type=>"coordinate"},
        ]
      }
    ]

    {
      intent: intent,
      payload: payload,
      slots: slots
    }
  end
end
