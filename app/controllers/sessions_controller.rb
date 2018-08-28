class SessionsController < ApplicationController
  
  # before_action :set_session


  def handover_chat
    @user    = User.find(params[:user_id])
    @user.current_session.try(:set_as_finished)
    
    unless params[:receiver_id].present?
      @session = @user.sessions.new(state: 'handed_over')
    else
      @session = @user.sessions.new(
        state: 'handed_over',
        conversation_started_at: Time.zone.now, 
        conversation_with_user_id: params[:receiver_id]
        )
    end
    

    respond_to do |format|
      if @session.save!
        format.json { render :show, status: :ok, location: @session }
      else
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end 

  def finish_conversation
    update = false

    @user    = User.find(params[:user_id])

    @session = @user.sessions.last
    
    if @session && @session.conversation_started_at.present?
      update = @session.update(
        conversation_started_at: nil, 
        conversation_with_user_id: nil)
    end


    respond_to do |format|
      if update
        format.json { render :show, status: :ok, location: @session }
      else
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end

  end
  
  def finish_handover_chat
    update = false

    @user    = User.find(params[:user_id])

    @session = @user.sessions.last

    respond_to do |format|
      if @session.try(:set_as_finished) 
        format.json { render :show, status: :ok, location: @session }
      else
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def session_params
      params.require(:session).permit(:state)
    end

end
