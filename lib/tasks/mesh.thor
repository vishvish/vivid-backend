require 'pry'
require 'hyperclient'
require 'erb'


class Mesh < Thor

  def initialize(*args)
    super
    @@api = Hyperclient.new(ENV['MESH_HOSTNAME']) do |client|
      client.connection(ssl: { verify: false }) do |conn|
        @@token = conn.post do |req|
          req.url 'auth/login'
          req.headers['Content-Type'] = 'application/json'
          req.body = '{ "username": "admin", "password": "admin" }'
        end.body['token']
      end
    end
  end

  desc "example", "an example task"
  def example
    puts "I'm a thor task!"
  end

  desc "schema FILE", "creates a schema from the JSON file"
  def schema(name, file)
    @name = "#{name}_#{Time.now.to_i}"
    @template = File.read(file)

    @@api.connection.post do |req|
      req.url 'schemas'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{@@token}"
      req.body = ERB.new(@template).result( binding )
    end
  rescue Exception => e
    puts e.message
  end
end
