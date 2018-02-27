require 'rails_helper'

describe Project, type: :model do
	it 'represents a Project in Gentics Mesh correctly' do
		expect(subject.attributes.keys.sort).to eq(["created", "creator", "edited", "editor", "name", "permissions", "rootNode", "schema", "uuid"])
	end

	it 'instantiates correctly' do
		attr = {
			"uuid"=>"217f8c981ada4642bf8c981adaa642c3",
			"name"=>"demo",
			"creator"=>{"uuid"=>"e5861ba26b914b21861ba26b91ab211a"},
			"created"=>"2017-12-07T10:26:43Z",
			"editor"=>{"uuid"=>"e5861ba26b914b21861ba26b91ab211a"},
			"edited"=>"2017-12-07T10:26:43Z",
			"rootNode"=>
			{"projectName"=>"demo",
		"uuid"=>"688f7beae8d240bf8f7beae8d2a0bf2e",
		"schema"=>{"name"=>"folder", "uuid"=>"6346df516cef487d86df516cef387d76"}},
			"permissions"=>{"create"=>true, "read"=>true, "update"=>true, "delete"=>true, "publish"=>true, "readPublished"=>true},
			"schema"=>nil
		}

    expect(described_class.new(attr)).to be_a Project
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
    expect(described_class.new(working)).to be_a Project
    expect{described_class.new(working).save}.to raise_error StandardError
  end

	it 'lists all the Projects' do
		VCR.use_cassette("project_list") do
			expect(described_class.all).to be_an(Array)
			expect(described_class.all.first).to be_a(Project)
		end
  end

  it 'finds a Project that exists' do
    VCR.use_cassette("project_find") do
      expect(described_class.find("217f8c981ada4642bf8c981adaa642c3")).to be_a Project
    end
  end

  it 'cannot find a Project that does not exist' do
    VCR.use_cassette("project_cannot_find") do
      expect{ described_class.find("xxxxxxxxxxxxxxxxxxxxxxxx") }.to raise_error ProjectError
    end
  end

  describe 'Project lifecycle' do
		let!(:project_name) { SecureRandom.hex }

		after(:each) do
			VCR.use_cassette("project_create_cleanup") do
				project = described_class.all.keep_if { |p| p.name == project_name }.first
				begin
					project.destroy
				rescue NoMethodError
				end
			end
		end

		it 'creates a new Project' do
			VCR.use_cassette("project_create") do
				expect{ described_class.new({ name: project_name }).save }.to_not raise_error
				# but no conflicting names
				expect{ described_class.new({ name: project_name }).save }.to raise_error ProjectError
			end
    end

    it 'creates and destroys a Project' do
			VCR.use_cassette("project_create_and_destroy") do
        project = described_class.new({ name: SecureRandom.hex }).save
        expect{ project.destroy }.to_not raise_error
			end
    end

	end
end
