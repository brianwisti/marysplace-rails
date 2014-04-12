require 'spec_helper'

describe ClientNotesController do
  setup :activate_authlogic

  let(:admin_user) { create :admin_user }
  let(:valid_attributes) { build_attributes :client_note }

  before { login admin_user }

  describe "GET index" do
    it "assigns all client_notes as @client_notes" do
      client_note = ClientNote.create! valid_attributes
      get :index
      assigns(:client_notes).should eq([client_note])
    end
  end

  describe "GET show" do
    it "assigns the requested client_note as @client_note" do
      client_note = ClientNote.create! valid_attributes
      get :show, {:id => client_note.to_param}
      assigns(:client_note).should eq(client_note)
    end
  end

  describe "GET new" do
    it "assigns a new client_note as @client_note" do
      get :new
      assigns(:client_note).should be_a_new(ClientNote)
    end
  end

  describe "GET edit" do
    it "assigns the requested client_note as @client_note" do
      client_note = ClientNote.create! valid_attributes
      get :edit, {:id => client_note.to_param}
      assigns(:client_note).should eq(client_note)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ClientNote" do
        expect {
          post :create, {:client_note => valid_attributes}
        }.to change(ClientNote, :count).by(1)
      end

      it "assigns a newly created client_note as @client_note" do
        post :create, {:client_note => valid_attributes}
        assigns(:client_note).should be_a(ClientNote)
        assigns(:client_note).should be_persisted
      end

      it "redirects to the created client_note" do
        post :create, {:client_note => valid_attributes}
        response.should redirect_to(ClientNote.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved client_note as @client_note" do
        # Trigger the behavior that occurs when invalid params are submitted
        ClientNote.any_instance.stub(:save).and_return(false)
        post :create, {:client_note => { "content" => nil }}
        assigns(:client_note).should be_a_new(ClientNote)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ClientNote.any_instance.stub(:save).and_return(false)
        post :create, {:client_note => { "title" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested client_note" do
        client_note = ClientNote.create! valid_attributes
        # Assuming there are no other client_notes in the database, this
        # specifies that the ClientNote created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ClientNote.any_instance.should_receive(:update_attributes).with({ "title" => "MyString" })
        put :update, {:id => client_note.to_param, :client_note => { "title" => "MyString" }}
      end

      it "assigns the requested client_note as @client_note" do
        client_note = ClientNote.create! valid_attributes
        put :update, {:id => client_note.to_param, :client_note => valid_attributes}
        assigns(:client_note).should eq(client_note)
      end

      it "redirects to the client_note" do
        client_note = ClientNote.create! valid_attributes
        put :update, {:id => client_note.to_param, :client_note => valid_attributes}
        response.should redirect_to(client_note)
      end
    end

    describe "with invalid params" do
      it "assigns the client_note as @client_note" do
        client_note = ClientNote.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ClientNote.any_instance.stub(:save).and_return(false)
        put :update, {:id => client_note.to_param, :client_note => { "title" => "invalid value" }}
        assigns(:client_note).should eq(client_note)
      end

      it "re-renders the 'edit' template" do
        client_note = ClientNote.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ClientNote.any_instance.stub(:save).and_return(false)
        put :update, {:id => client_note.to_param, :client_note => { "title" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested client_note" do
      client_note = ClientNote.create! valid_attributes
      expect {
        delete :destroy, {:id => client_note.to_param}
      }.to change(ClientNote, :count).by(-1)
    end

    it "redirects to the client_notes list" do
      client_note = ClientNote.create! valid_attributes
      delete :destroy, {:id => client_note.to_param}
      response.should redirect_to(client_notes_url)
    end
  end

end
