require 'net/http'
require 'json'

class Interface 
  def buscar_commits

  end

  def http_get(user, repositorio)
    # uri = URI('https://api.github.com/repos/WlademirRenan/sistema_base_adminlte_2016/commits')
    uri = URI("https://api.github.com/repos/#{user}/#{repositorio}/commits")
    response =  Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
end
