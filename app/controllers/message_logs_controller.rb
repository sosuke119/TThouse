class MessageLogsController < ApplicationController
  # POST /message_logs
  # POST /message_logs.json

  def deliver
    @message_log = MessageLog.new(message_log_params)
    
    message = {text: @message_log.text}
    
    bot_deliver = BotDeliver.new(
      user: @message_log.user, 
      message: message)
    bot_deliver.send
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message_log
      @message_log = MessageLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_log_params
      params.require(:message_log).permit(:text, :user_id)
    end

end
