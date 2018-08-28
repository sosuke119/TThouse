class MessageLog < ApplicationRecord

  after_create :update_session_last_messaged_at

  belongs_to :user
  belongs_to :session
  has_many :message_attachments, dependent: :destroy

  def update_session_last_messaged_at
    self.session.update(last_messaged_at: self.created_at)
  end

end
