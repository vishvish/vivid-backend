class Schema < ActiveResource::Base
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON
  attr_accessor :uuid, :creator, :created, :editor, :edited, :name, :displayField, :segmentField, :container, :version, :permissions, :fields, :urlFields, :description

  def attributes
    {
      'uuid' => nil,
      'name' => nil,
      'creator' => nil,
      'created' => nil,
      'editor' => nil,
      'edited' => nil,
      'displayField' => nil,
      'segmentField' => nil,
      'permissions' => nil,
      'fields' => nil,
      'urlFields' => nil,
      'description' => nil
    }
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def self.list
    response = RestClient.get("#{ENV['MESH_HOSTNAME']}/schemas")
    list = JSON.parse(response.body)['data']
    list.collect! { |schema| Schema.new(schema) }
  end

  def self.get_root_folder
    schemas = Schema.list
    schemas.select { |s| s.name == 'folder' }.first
  end

end
