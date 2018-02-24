class Project
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON
  attr_accessor :uuid, :creator, :created, :editor, :edited, :name, :rootNode, :permissions, :schema

  def attributes
    {
      'uuid' => nil,
      'name' => nil,
      'creator' => nil,
      'created' => nil,
      'editor' => nil,
      'edited' => nil,
      'rootNode' => nil,
      'permissions' => nil,
      'schema' => nil
    }
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def self.list
    response = RestClient.get("#{ENV['MESH_HOSTNAME']}/projects")
    list = JSON.parse(response.body)['data']
    list.collect! { |project| Project.new(project) }
  end

  def self.find(uuid)
    begin
      response = RestClient.get("#{ENV['MESH_HOSTNAME']}/projects/#{uuid}")
    rescue RestClient::NotFound => e
      raise ProjectError, "Project not found"
    else
      hash = JSON.parse(response.body)
      Project.new(hash)
    end
  end

  def save
    self.schema = { 'name' => 'folder', 'uuid' => Schema.get_root_folder.uuid }
    begin
      response = RestClient.post("#{ENV['MESH_HOSTNAME']}/projects", self.to_json, { content_type: :json, accept: :json, :Authorization => 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyVXVpZCI6ImU1ODYxYmEyNmI5MTRiMjE4NjFiYTI2YjkxYWIyMTFhIiwiaWF0IjoxNTE5NTEwMTc4LCJleHAiOjE1MjMxMTAxNzh9.r7NKCufd38GbIYAkKpPkW2s1khRsrMGDi9f1KL-d5nM' })
    rescue RestClient::NotFound => e
      raise ProjectError, "Project not found"
    rescue RestClient::Conflict => e
      return e.message
    else
      return response.body
    end
  end

end

class ProjectError < StandardError
end
