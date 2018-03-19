require 'rails_helper'

describe SchemasController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Schema. As you add validations to Schema, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SchemasController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      schema = Schema.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      schema = Schema.create! valid_attributes
      get :show, params: {id: schema.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      schema = Schema.create! valid_attributes
      get :edit, params: {id: schema.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Schema" do
        VCR.use_cassette("schema_controller_create") do
          expect {
            post :create, params: {schema: valid_attributes}, session: valid_session
          }.to change(Schema, :count).by(1)
        end
      end

      it "redirects to the created schema" do
        post :create, params: {schema: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Schema.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {schema: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested schema" do
        schema = Schema.create! valid_attributes
        put :update, params: {id: schema.to_param, schema: new_attributes}, session: valid_session
        schema.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the schema" do
        schema = Schema.create! valid_attributes
        put :update, params: {id: schema.to_param, schema: valid_attributes}, session: valid_session
        expect(response).to redirect_to(schema)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        schema = Schema.create! valid_attributes
        put :update, params: {id: schema.to_param, schema: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested schema" do
      schema = Schema.create! valid_attributes
      expect {
        delete :destroy, params: {id: schema.to_param}, session: valid_session
      }.to change(Schema, :count).by(-1)
    end

    it "redirects to the schemas list" do
      schema = Schema.create! valid_attributes
      delete :destroy, params: {id: schema.to_param}, session: valid_session
      expect(response).to redirect_to(schemas_url)
    end
  end

end
