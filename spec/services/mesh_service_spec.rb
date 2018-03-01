require 'rails_helper'

describe MeshService do
  subject { MeshService.new }

  it "has the correct credentials" do
		VCR.use_cassette("mesh_service_authenticate") do
      expect(described_class.authenticate()).to eq 200
      expect(described_class.class_variable_get("@@token")).to_not be_empty
		end
  end

  it "has the incorrect credentials" do
		VCR.use_cassette("mesh_service_authenticate_failed") do
      expect(described_class.authenticate(false)).to eq 401
      expect(described_class.class_variable_get("@@token")).to be_nil
		end
  end

  it "authenticates if there is no token" do
		VCR.use_cassette("mesh_service_get_token") do
      expect(described_class.token).to_not be_nil
    end
  end

  it "returns the token if it exists already" do
		VCR.use_cassette("mesh_service_get_stored_token") do
      expect(described_class.authenticate()).to eq 200
      expect(described_class.token).to_not be_nil
    end
  end

end
