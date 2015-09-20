require 'rails_helper'

describe ClientNotesController, :type => :controller do
  setup :activate_authlogic
  fixtures :client_notes, :clients, :users

  let(:client) { clients :amy_a }
  let(:client_note) { client_notes :amy_a_bonus }
  let(:admin) { users :admin }
  let(:valid_attributes) do
  end

  before do
    @attributes = {
      title: "Note Title",
      content: "Note Content",
      user_id: admin.id,
      client_id: client.id
    }

    login users :admin
  end

  describe "GET index" do
    it "assigns all client_notes as client_notes" do
      get :index
      expect(assigns(:client_notes)).to eq([client_note])
    end
  end

  describe "GET show" do
    it "assigns the requested client_note as @client_note" do
      get :show, id: client_note
      expect(assigns(:client_note)).to eq(client_note)
    end
  end

  describe "GET new" do
    it "assigns a new client_note as @client_note" do
      get :new
      expect(assigns(:client_note)).to be_a_new(ClientNote)
    end
  end

  describe "GET edit" do
    it "assigns the requested client_note as @client_note" do
      client_note = ClientNote.create! @attributes
      get :edit, {:id => client_note.to_param}
      expect(assigns(:client_note)).to eq(client_note)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ClientNote" do
        expect {
          post :create, client_note: @attributes
        }.to change(ClientNote, :count).by(1)
      end

      it "assigns a newly created client_note as @client_note" do
        post :create, client_note: @attributes
        expect(assigns(:client_note)).to be_a(ClientNote)
        expect(assigns(:client_note)).to be_persisted
      end

      it "redirects to the created client_note" do
        post :create, client_note: @attributes
        expect(response).to redirect_to(ClientNote.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved client_note as @client_note" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(ClientNote).to receive(:save).and_return(false)
        post :create, {:client_note => { "content" => nil }}
        expect(assigns(:client_note)).to be_a_new(ClientNote)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(ClientNote).to receive(:save).and_return(false)
        post :create, {:client_note => { "title" => "invalid value" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested client_note" do
        client_note = ClientNote.create! @attributes
        # Assuming there are no other client_notes in the database, this
        # specifies that the ClientNote created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        put :update, {:id => client_note.to_param, :client_note => { "title" => "MyString" }}
      end

      it "assigns the requested client_note as @client_note" do
        put :update, id: client_note, :client_note => @attributes
        expect(assigns(:client_note)).to eq(client_note)
      end

      it "redirects to the client_note" do
        put :update, id: client_note, client_note: @attributes
        expect(response).to redirect_to(client_note)
      end
    end

    describe "with invalid params" do
      it "assigns the client_note as @client_note" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(ClientNote).to receive(:save).and_return(false)
        put :update, id: client_note, client_note: { title: "invalid value" }
        expect(assigns(:client_note)).to eq(client_note)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(ClientNote).to receive(:save).and_return(false)
        put :update, id: client_note, client_note: { "title" => "invalid value" }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested client_note" do
      expect {
        delete :destroy, id: client_note
      }.to change(ClientNote, :count).by(-1)
    end

    it "redirects to the client_notes list" do
      delete :destroy, id: client_note
      expect(response).to redirect_to(client_notes_url)
    end
  end

end
