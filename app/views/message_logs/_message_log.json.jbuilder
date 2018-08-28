json.extract! message_log, :id, :text, :user_id, :message_type, :created_at, :updated_at
json.url message_log_url(message_log, format: :json)
