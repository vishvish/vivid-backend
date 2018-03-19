class Schema
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON
  attr_accessor :uuid, :creator, :created, :editor, :edited, :name, :displayField, :segmentField, :container, :version, :permissions, :fields, :urlFields, :description, :container

  def fields
    @fields ||= []
  end

  def urlFields
    @urlFields ||= []
  end

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
      'description' => nil,
      'container' => nil
    }
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def self.all
    url = ENV['MESH_HOSTNAME'] + '/schemas'
    begin
      response = RestClient.get(url, headers={ content_type: 'application/json', authorization: "Bearer #{MeshService.token}" })
      @@token = JSON.parse(response.body)['token']
    rescue RestClient::Unauthorized => err
      return err.response.code
    end
    # JSON.parse(response.body)['data']
    # response = RestClient.get("#{ENV['MESH_HOSTNAME']}/schemas")
    list = JSON.parse(response.body)['data']
    list.collect! { |schema| Schema.new(schema) }
  end

  def self.count
    url = ENV['MESH_HOSTNAME'] + '/schemas'
    begin
      response = RestClient.get(url, headers={ content_type: 'application/json', authorization: "Bearer #{MeshService.token}" })
      @@token = JSON.parse(response.body)['token']
    rescue RestClient::Unauthorized => err
      return err.response.code
    end
    list = JSON.parse(response.body)['data']
    list.length
  end

  def self.find(uuid)
    begin
      response = RestClient.get("#{ENV['MESH_HOSTNAME']}/schemas/#{uuid}", { content_type: :json, accept: :json, :Authorization => "Bearer #{MeshService.token}" })
    rescue RestClient::NotFound
      raise SchemaError, "Schema not found"
    else
      hash = JSON.parse(response.body)
      Schema.new(hash)
    end
  end

  def self.get_root_folder
    schemas = Schema.all
    schemas.select { |s| s.name == 'folder' }.first
  end

  def self.create!(attrs)
    s = Schema.new(attrs).save
  end

  def save
    begin
      response = RestClient.post("#{ENV['MESH_HOSTNAME']}/schemas", self.to_json, { content_type: :json, accept: :json, :Authorization => "Bearer #{MeshService.token}" })
    rescue RestClient::NotFound => e
      raise SchemaError, "Schema not found"
    rescue RestClient::Conflict => e
      raise SchemaError, "Schema name conflict"
    rescue RestClient::BadRequest => e
      raise SchemaError, "Bad Request: #{e.response.body}"
    rescue RestClient::InternalServerError => e
      # binding.pry
      raise SchemaError, "Internal Server Error: #{e.response.body}"
    else
      Schema.new(JSON.parse(response.body))
    end
  end

  def destroy
    begin
      response = RestClient.delete("#{ENV['MESH_HOSTNAME']}/schemas/#{self.uuid}", { content_type: :json, accept: :json, :Authorization => "Bearer #{MeshService.token}" })
    rescue RestClient::NotFound => e
      raise SchemaError, "Schema not found"
    rescue RestClient::Conflict => e
      return e.message
    rescue RestClient::BadRequest => e
    else
      return response.body
    end
  end
end

class SchemaError < StandardError
end
