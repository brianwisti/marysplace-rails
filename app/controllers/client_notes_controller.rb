# Routes for notes from staff about specific clients
class ClientNotesController < ApplicationController
  before_filter :require_user

  # GET /client_notes
  # GET /client_notes.json
  def index
    authorize! :show, ClientNote
    load_client_notes
  end

  # GET /client_notes/1
  # GET /client_notes/1.json
  def show
    authorize! :show, ClientNote
    load_client_note
  end

  # GET /client_notes/new
  # GET /client_notes/new.json
  def new
    authorize! :create, ClientNote
    @client_note = ClientNote.new

    if params[:client]
      @client = Client.find params[:client]
    end

    @client ||= Client.new
    @client_note.client = @client
  end

  # GET /client_notes/1/edit
  def edit
    @client_note = ClientNote.find(params[:id])
    if @client_note
      authorize! :edit, @client_note
      @client = @client_note.client
    end
  end

  # POST /client_notes
  # POST /client_notes.json
  def create
    authorize! :create, ClientNote
    @client_note = ClientNote.new client_note_params
    @client_note.user = current_user

    if @client_note.save
      redirect_to @client_note
    else
      render :new
    end
  end

  # PUT /client_notes/1
  # PUT /client_notes/1.json
  def update
    @client_note = ClientNote.find(params[:id])
    authorize! :edit, @client_note

    if @client_note.update_attributes client_note_params
      redirect_to @client_note
    else
      render :edit
    end
  end

  # DELETE /client_notes/1
  # DELETE /client_notes/1.json
  def destroy
    @client_note = ClientNote.find(params[:id])
    authorize! :destroy, @client_note
    @client_note.destroy
    redirect_to client_notes_url
  end

  private

  def client_note_params
    params.require(:client_note).permit(:title, :content, :client_id, :user_id)
  end

  def load_client_notes
    @client_notes ||= ClientNote.page params[:page]
  end

  def load_client_note
    @client_note ||= ClientNote.find(params[:id])
  end
end
