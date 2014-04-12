class ClientNotesController < ApplicationController
  before_filter :require_user

  # GET /client_notes
  # GET /client_notes.json
  def index
    authorize! :show, ClientNote
    @client_notes = ClientNote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @client_notes }
    end
  end

  # GET /client_notes/1
  # GET /client_notes/1.json
  def show
    authorize! :show, ClientNote
    @client_note = ClientNote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client_note }
    end
  end

  # GET /client_notes/new
  # GET /client_notes/new.json
  def new
    authorize! :create, ClientNote
    @client_note = ClientNote.new
    @client = Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client_note }
    end
  end

  # GET /client_notes/1/edit
  def edit
    authorize! :edit, ClientNote
    @client_note = ClientNote.find(params[:id])
    @client = @client_note.client
  end

  # POST /client_notes
  # POST /client_notes.json
  def create
    authorize! :create, ClientNote
    @client_note = ClientNote.new(params[:client_note])
    @client_note.user = current_user

    respond_to do |format|
      if @client_note.save
        format.html { redirect_to @client_note, notice: 'Client note was successfully created.' }
        format.json { render json: @client_note, status: :created, location: @client_note }
      else
        format.html { render action: "new" }
        format.json { render json: @client_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /client_notes/1
  # PUT /client_notes/1.json
  def update
    authorize! :edit, ClientNote
    @client_note = ClientNote.find(params[:id])

    respond_to do |format|
      if @client_note.update_attributes(params[:client_note])
        format.html { redirect_to @client_note, notice: 'Client note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @client_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_notes/1
  # DELETE /client_notes/1.json
  def destroy
    authorize! :destroy, ClientNote
    @client_note = ClientNote.find(params[:id])
    @client_note.destroy

    respond_to do |format|
      format.html { redirect_to client_notes_url }
      format.json { head :no_content }
    end
  end
end
