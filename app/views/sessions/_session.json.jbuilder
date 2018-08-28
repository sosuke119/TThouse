json.extract! session, :id, :user_id, :state,:status, :created_at, :updated_at, :conversation_with_user_id, :finished_at
json.url session_url(session, format: :json)
