module Mesh
  class Schemas
    def list
      url = ENV['MESH_HOSTNAME'] + 'schemas'
      begin
        response = RestClient.get(url, headers={ content_type: 'application/json', authorization: "Bearer #{MeshService.token}" })
        @@token = JSON.parse(response.body)['token']
      rescue RestClient::Unauthorized => err
        return err.response.code
      end
      JSON.parse(response.body)['data']
    end

    def create(schema)
      url = ENV['MESH_HOSTNAME'] + 'schemas'
      begin
        response = RestClient.post(url, schema, headers={ content_type: 'application/json', authorization: "Bearer #{MeshService.token}" })
      rescue RestClient::BadRequest => err
        return err.response.code
      rescue RestClient::Unauthorized => err
        return err.response.code
      end
      JSON.parse(response.body)['uuid']
    end

    def delete(uuid)
      url = ENV['MESH_HOSTNAME'] + "schemas/#{uuid}"
      begin
        response = RestClient.delete(url, headers={ content_type: 'application/json', authorization: "Bearer #{MeshService.token}" })
      rescue RestClient::BadRequest => err
        return err.response.code
      rescue RestClient::Unauthorized => err
        return err.response.code
      end
      response.code
    end



    def find(name)
      list().keep_if { |s| s['name'] == name }.first
    end

    def find_uuid(name)
      find(name)['uuid']
    end
  end
end

