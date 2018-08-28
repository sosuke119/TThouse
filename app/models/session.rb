class Session < ApplicationRecord
  belongs_to :user

  belongs_to :trigger, :polymorphic => true, optional: true

  has_many :message_logs
  has_many :session_slots, dependent: :destroy

  before_create :change_status
  before_update :change_status

  def not_expried
    start_time = self.last_messaged_at || self.created_at
    (  start_time + 15.minutes ) > Time.zone.now
  end

  def unfinished
    self.finished_at.blank?
  end

  def set_as_expired
    start_time = self.last_messaged_at  || self.created_at
    self.update(expired_at:start_time  + 15.minutes)
  end

  def set_as_finished
    if self.not_expried && self.unfinished
      if self.update(finished_at: Time.zone.now)
        true
      else
        false
      end
    else
      false
    end
  end

  def in_conversation
    self.conversation_started_at.present?
  end

  def receiver
    User.where(id:self.conversation_with_user_id).first
  end

private
  
  def change_status

    if self.state == 'handed_over'
      self.status = 'handed_over'
    end

    if self.conversation_started_at
      self.status = 'conversation'
    end

    if self.finished_at or self.expired_at
      self.status = 'done'
    end
  end


end
