require 'rails_helper'

describe Schema, type: :model do
	it 'represents a Schema in Gentics Mesh correctly' do
		expect(subject.attributes.keys.sort).to eq(["container", "created", "creator", "description", "displayField", "edited", "editor", "fields", "name", "permissions", "segmentField", "urlFields", "uuid"])
	end

	it 'instantiates correctly' do
		attr = {
			"uuid"=>"217f8c981ada4642bf8c981adaa642c3",
			"name"=>"demo",
			"creator"=>{"uuid"=>"e5861ba26b914b21861ba26b91ab211a"},
			"created"=>"2017-12-07T10:26:43Z",
			"editor"=>{"uuid"=>"e5861ba26b914b21861ba26b91ab211a"},
			"edited"=>"2017-12-07T10:26:43Z",
			"permissions"=>{"create"=>true, "read"=>true, "update"=>true, "delete"=>true, "publish"=>true, "readPublished"=>true},
      "container"=>false
		}

    expect(described_class.new(attr)).to be_a Schema
    expect(described_class.new.attributes=attr).to be_a Hash
    expect(described_class.new.attributes=attr).to eq attr
	end

	it 'validates correctly' do
		broken = {
      "foo" => "bar"
		}
    expect{described_class.new(broken)}.to raise_error ActiveModel::UnknownAttributeError
    expect{described_class.new(broken).save}.to raise_error ActiveModel::UnknownAttributeError

		working = {
      "name" => SecureRandom.hex
		}
    expect(described_class.new(working)).to be_a Schema
    expect{described_class.new(working).save}.to raise_error StandardError
  end

  it 'lists all the Schemas' do
		VCR.use_cassette("schema_list") do
			expect(described_class.all).to be_an(Array)
			expect(described_class.all.first).to be_a(Schema)
		end
  end

  it 'finds a Schema that exists' do
    VCR.use_cassette("schema_find") do
      expect(described_class.find("6346df516cef487d86df516cef387d76")).to be_a Schema
    end
  end

  it 'cannot find a Schema that does not exist' do
    VCR.use_cassette("schema_cannot_find") do
      expect{ described_class.find("xxxxxxxxxxxxxxxxxxxxxxxx") }.to raise_error SchemaError
    end
  end

  describe 'Lifecycle' do
    let!(:schema_name) { [*('A'..'Z')].sample(8).join }

		after(:each) do
			VCR.use_cassette("schema_create_cleanup") do
				schema = described_class.all.keep_if { |p| p.name == schema_name }.first
				begin
					schema.destroy
				rescue NoMethodError
				end
			end
		end

		it 'creates a new Schema' do
			VCR.use_cassette("schema_create") do
				expect{ described_class.new({ name: schema_name }).save }.to_not raise_error
				# but no conflicting names
				expect{ described_class.new({ name: schema_name }).save }.to raise_error SchemaError
			end
    end

    it 'creates and destroys a Schema' do
			VCR.use_cassette("schema_create_and_destroy") do
        schema = described_class.new({ name: [*('A'..'Z')].sample(8).join }).save
        expect{ schema.destroy }.to_not raise_error
			end
    end

	end
end
