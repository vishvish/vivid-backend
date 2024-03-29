require 'pry'
require 'hyperclient'
require 'erb'
require './config/environment'

class Mesh < Thor

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

  desc "example", "an example task"
  def example
    puts "I'm a thor task!"
  end

  desc "schema FILE", "creates a schema from the JSON file"
  def schema(name, file)
    @name = "#{name}"
    @description = "#{name}_#{Time.now.to_i}"
    @template = File.read(file)

    # create schema in API
    @@api.connection.post do |req|
      req.url 'schemas'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{@@token}"
      req.body = ERB.new(@template).result( binding )
    end
    
    mh = MeshHelpers.new
    permissions = {"permissions"=>{"create"=>false, "read"=>true, "update"=>false, "delete"=>false, "publish"=>false, "readPublished"=>false}}
    response = mh.set_permissions_for_role_on_schema('anonymous', name, permissions)
  rescue Exception => e
    puts e.message
  end

end
