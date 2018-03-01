class MeshService
  @@token = nil

  def self.authenticate(use_env = true, username = nil, password = nil)
    @@token = nil
    u = use_env ? ENV['MESH_USERNAME'] : username
    p = use_env ? ENV['MESH_PASSWORD'] : password
    payload = {"username"=>"#{u}", "password"=>"#{p}"}
    url = ENV['MESH_HOSTNAME'] + '/auth/login'
    begin
      response = RestClient.post(url, payload.to_json, headers={ content_type: 'application/json'})
      @@token = JSON.parse(response.body)['token']
    rescue RestClient::Unauthorized => err
      return err.response.code
    end
    response.code
  end

  def self.token
    if @@token
      return @@token
    else
      self.authenticate
      return @@token
    end
  end

end
