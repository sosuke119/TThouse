class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy]

  # GET /chatrooms
  # GET /chatrooms.json
  def index

    User.includes(:chatroom_users).all.each do |u|

      next unless u.chatroom_users.count < 1
      chatroom = Chatroom.create!(name: u.name)
      u.chatroom_users.create!(chatroom:chatroom)
    end


    @chatrooms = Chatroom.all
    chatrooms_hash = []
    @chatrooms.each do |c|
      next if c.users.first.sessions.count == 0
      hash = c.attributes
      user = c.users.first

      
      hash[:user]           = user.attributes
      hash[:user][:session] = user.sessions.last
      message_logs = c.message_logs.order(created_at: :desc).first(100).reverse
      
      hash[:message_logs] = []
      message_logs.each do |m| 
        m_hash = m.attributes
        m_hash[:echo_attachments] =  m.echo_attachments if m.echo_attachments.present?
        hash[:message_logs] << m_hash
      end
      chatrooms_hash << hash
    end
    

    @chatrooms_json = chatrooms_hash.to_json

  end

  

  # GET /chatrooms/1
  # GET /chatrooms/1.json
  def show
  end

  # GET /chatrooms/new
  def new
    @chatroom = Chatroom.new
  end

  # GET /chatrooms/1/edit
  def edit
  end

  # POST /chatrooms
  # POST /chatrooms.json
  def create
    @chatroom = Chatroom.new(chatroom_params)

    respond_to do |format|
      if @chatroom.save
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully created.' }
        format.json { render :show, status: :created, location: @chatroom }
      else
        format.html { render :new }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chatrooms/1
  # PATCH/PUT /chatrooms/1.json
  def update
    respond_to do |format|
      if @chatroom.update(chatroom_params)
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully updated.' }
        format.json { render :show, status: :ok, location: @chatroom }
      else
        format.html { render :edit }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chatrooms/1
  # DELETE /chatrooms/1.json
  def destroy
    @chatroom.destroy
    respond_to do |format|
      format.html { redirect_to chatrooms_url, notice: 'Chatroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatroom
      @chatroom = Chatroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chatroom_params
      params.require(:chatroom).permit(:name)
    end
end

