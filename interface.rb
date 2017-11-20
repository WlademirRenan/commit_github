require 'net/http'
require 'json'
# name;email;login;avatar_url;commits_count
# entrada https://github.com/Dinda-com-br/braspag-rest
# saida  nomedoprojeto-datahora.txt
class Interface
  def buscar_commits(url)
    url_separada = url.split('/')
    repositorio = url_separada.pop
    user = url_separada.pop

    result = http_get(user, repositorio)
    commits_classificados = classificar_commits(result)
    gerar_arquivo(commits_classificados, repositorio)
  end

  def http_get(user, repositorio)
    # uri = URI('https://api.github.com/repos/WlademirRenan/sistema_base_adminlte_2016/commits')
    uri = URI("https://api.github.com/repos/#{user}/#{repositorio}/commits")
    response =  Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

  def classificar_commits(result)
    lista = Array.new
    result.each do |commit|
      puts commit['commit']['author']['name']
      detalhes = Hash.new
      detalhes['name']       = commit['commit']['author']['name']
      detalhes['email']      = commit['commit']['author']['email']
      detalhes['login']      = commit['author'].is_a?(Hash) ? commit['author']['login'] : nil
      detalhes['avatar_url'] = commit['author'].is_a?(Hash) ? commit['author']['avatar_url'] : nil
      
      lista << detalhes
    end
    lista

    #counts = Hash.new 0
    
    #words.each do |word|
    #  counts[word] += 1
    #end
    
  
  end

  def gerar_arquivo(commits_classificados, repositorio)

  end
end
