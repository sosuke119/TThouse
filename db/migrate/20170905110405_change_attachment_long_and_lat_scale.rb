class ChangeAttachmentLongAndLatScale < ActiveRecord::Migration[5.1]
  def change
    change_column :message_attachments, :lat ,:decimal , precision:15 ,scale: 10
    change_column :message_attachments, :long ,:decimal , precision:15 ,scale: 10
  end
end
