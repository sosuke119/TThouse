module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      if self.current_user.present?
        logger.add_tags "ActionCable", "User #{current_user.id}"
      end
    end

    protected

      def find_verified_user
        if current_user = env['warden'].user
          current_user
        # elsif 

        # else
        #   reject_unauthorized_connection
        end
      end
  end
end
