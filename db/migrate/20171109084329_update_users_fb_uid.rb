class UpdateUsersFbUid < ActiveRecord::Migration[5.1]
  def change

    User.all.each do |user|
      user.get_fb_asid_with_chatbot_sender_id('update')
    end

  end
end
