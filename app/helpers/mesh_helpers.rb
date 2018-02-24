require 'pry'
require 'hyperclient'
require 'ostruct'

class MeshHelpers
  def initialize(*args)
    super
    auth_body = {"username"=>"#{ENV['MESH_USERNAME']}", "password"=>"#{ENV['MESH_PASSWORD']}"}

    @@api = Hyperclient.new(ENV['MESH_HOSTNAME']) do |client|
      client.connection(ssl: { verify: false }) do |conn|
        @@token = conn.post do |req|
          req.url 'auth/login'
          req.headers['Content-Type'] = 'application/json'
          req.body = auth_body.to_json
        end.body['token']
      end
    end
    @@api._response.status
  end

  def get_object(object_type, name)
    response = @@api.connection.get do |req|
      req.url object_type
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{@@token}"
    end
    obj = response.body["data"].select{ |obj| obj["name"] == name }[0]
    OpenStruct.new(obj)
  end

  def get_permissions_for_role_on_schema(role, schema)
    role_uuid = get_object('roles', role).uuid
    schema_uuid = get_object('schemas', schema).uuid

    response = @@api.connection.get do |req|
      req.url "roles/#{role_uuid}/permissions/schemas/#{schema_uuid}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{@@token}"
    end
    response.body
  end

  def set_permissions_for_role_on_schema(role, schema, permissions)
    role_uuid = get_object('roles', role).uuid
    schema_uuid = get_object('schemas', schema).uuid

    response = @@api.connection.post do |req|
      req.url "roles/#{role_uuid}/permissions/schemas/#{schema_uuid}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{@@token}"
      req.body = permissions.to_json
    end
    response.status
  end

end
