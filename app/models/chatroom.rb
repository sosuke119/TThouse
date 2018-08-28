class Chatroom < ApplicationRecord
  has_many :chatroom_users
  has_many :users, through: :chatroom_users
  has_many :message_logs, through: :users
  has_many :sessions,     through: :users

end
