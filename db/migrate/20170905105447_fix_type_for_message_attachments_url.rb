class FixTypeForMessageAttachmentsUrl < ActiveRecord::Migration[5.1]
  def change
    change_column :message_attachments, :url, :text
  end
end
