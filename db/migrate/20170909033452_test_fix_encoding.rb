class TestFixEncoding < ActiveRecord::Migration[5.1]
  def change

    # execute "ALTER TABLE `users` DROP INDEX index_users_on_sender_id;"
    # execute "ALTER TABLE `users` DROP INDEX index_users_on_reset_password_token;"
    execute "ALTER TABLE `users` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    execute "ALTER TABLE `users` MODIFY `sender_id` VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    execute "ALTER TABLE `users` MODIFY `reset_password_token` VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    execute "ALTER TABLE  `users` ADD UNIQUE index_users_on_sender_id (sender_id);"
    execute "ALTER TABLE  `users` ADD UNIQUE index_users_on_reset_password_token (reset_password_token);"

    char_set = 'utf8mb4'
    collation = 'utf8mb4_unicode_ci'
    table_names = ['intentions','message_attachments' ,'message_logs' ,'properties' ,'replies']
    table_names.each do |table_name|
      execute "ALTER TABLE `#{table_name}` CONVERT TO CHARACTER SET #{char_set} COLLATE #{collation};"
    end

  end
end
