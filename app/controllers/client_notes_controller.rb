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
    build_client_note
  end

  # GET /client_notes/1/edit
  def edit
    load_client_note

    if @client_note
      authorize! :edit, @client_note
      @client = @client_note.client
    end
  end

  # POST /client_notes
  # POST /client_notes.json
  def create
    authorize! :create, ClientNote
    build_client_note
    save_client_note or render :new
  end

  # PUT /client_notes/1
  # PUT /client_notes/1.json
  def update
    load_client_note
    authorize! :edit, @client_note
    build_client_note
    save_client_note or render :edit
  end

  # DELETE /client_notes/1
  # DELETE /client_notes/1.json
  def destroy
    load_client_note

    authorize! :destroy, @client_note
    @client_note.destroy
    redirect_to client_notes_url
  end

  private

  def client_note_params
    client_note_params = params[:client_note]

    if client_note_params
      client_note_params.permit(:title, :content, :client_id, :user_id)
    else
      {}
    end
  end

  def load_client_notes
    @client_notes ||= ClientNote.page params[:page]
  end

  def load_client_note
    @client_note ||= ClientNote.find(params[:id])
  end

  def build_client_note
    @client_note ||= ClientNote.new
    @client_note.attributes = client_note_params

    if params[:client]
      @client ||= Client.find params[:client]
      @client_note.client = @client
    end

    @client_note.user ||= current_user
  end

  def save_client_note
    if @client_note.save
      redirect_to @client_note
    end
  end
end
