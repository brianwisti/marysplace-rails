class MessagesController < ApplicationController
  before_filter :require_user

  # GET /messages
  def index
    authorize! :show, Message
    load_messages
    current_user.messages_checked
  end

  # GET /messages/1
  def show
    authorize! :show, Message
    load_message
  end

  # GET /messages/new
  def new
    authorize! :create, Message
    build_message
  end

  # GET /messages/1/edit
  def edit
    authorize! :edit, Message
    load_message
  end

  # POST /messages
  def create
    authorize! :create, Message
    build_message
    save_message or render :new
  end

  # PUT /messages/1
  def update
    authorize! :update, Message
    load_message
    build_message
    save_message or render :edit
  end

  # DELETE /messages/1
  def destroy
    authorize! :destroy, Message
    load_message
    destroy_message

    redirect_to messages_url
  end

  private

  def message_params
    message_params = params[:message]

    if message_params
      message_params.permit(:content)
    else
      {}
    end
  end

  def load_messages
    @messages ||= Message.order("created_at DESC")
  end

  def load_message
    @message ||= Message.find params[:id]
  end

  def build_message
    @message = Message.new
    @message.attributes = message_params
    @message.author ||= current_user
  end

  def save_message
    if @message.save
      redirect_to @message
    end
  end

  def destroy_message
    @message.destroy
  end
end
