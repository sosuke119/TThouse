
admin = User.where(role:'admin').first


if admin.present?
else
  new_admin = User.where(first_name:"立青",last_name:"涂").first
  new_admin.update(role:'admin') if new_admin.present?
end

Slot.migrate



# bot_api = ChatroomSetting.new

# 核准機器人的 domain 
# bot_api.whitelist

# 開始按鈕
# bot_api.set_start_button
# bot_api.delete_welcome_button

# 歡迎語
# bot_api.set_greeting

# 菜單
# bot_api.delete_menu
# bot_api.set_menu

case Rails.env
when "development"

when "production" , "staging"
  
end