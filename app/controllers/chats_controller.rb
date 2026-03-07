class ChatsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @session = current_user.active_chat_session
    @messages = @session.chat_messages.order(:created_at)
  end
  
  def create
    @session = current_user.active_chat_session
    chatbot = ChatbotService.new(current_user)
    
    result = chatbot.send_message(params[:message], @session)
    
    respond_to do |format|
      format.json { render json: result }
      format.html do
        if result[:success]
          redirect_to chat_path
        else
          flash[:alert] = "Error: #{result[:error]}"
          redirect_to chat_path
        end
      end
    end
  end
  
  def new_session
    current_user.chat_sessions.active.each(&:end_session!)
    redirect_to chat_path, notice: 'Started a new conversation'
  end
  
  def destroy
    @session = current_user.chat_sessions.find(params[:id])
    @session.end_session!
    redirect_to chat_path, notice: 'Chat session ended'
  end
end
