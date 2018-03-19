require 'rails_helper'

RSpec.describe "Schemas", type: :request do
  describe "GET /schemas" do
    it "works! (now write some real specs)" do
      VCR.use_cassette("schema_request_get") do
        get schemas_path
        expect(response).to have_http_status(200)
      end
    end
  end
end
