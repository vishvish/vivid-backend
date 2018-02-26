require 'rails_helper'

describe Project, type: :model do
  it 'represents a Project in Gentics Mesh correctly' do
    expect(subject.attributes.keys.sort).to eq(["created", "creator", "edited", "editor", "name", "permissions", "rootNode", "schema", "uuid"])
  end

  it 'lists all the Projects in Gentics Mesh' do
    VCR.use_cassette("project_list") do
      expect(described_class.all).to be_an(Array)
      expect(described_class.all.first).to be_a(Project)
    end
  end

  describe 'Project creation' do
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

    it 'creates a new Project in Gentics Mesh' do
      VCR.use_cassette("project_create") do
        expect{ described_class.new({ name: project_name }).save }.to_not raise_error
        # but no conflicting names
        expect{ described_class.new({ name: project_name }).save }.to raise_error ProjectError
      end
    end

  end
end
