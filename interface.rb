require 'net/http'
require 'json'

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
    uri = URI("https://api.github.com/repos/#{user}/#{repositorio}/commits")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

  def classificar_commits(result)
    lista = Hash.new
    result.each do |commit|
      chave = commit['author'].is_a?(Hash) ? commit['author']['login'] : commit['commit']['author']['email']
      if lista[chave].is_a?(Hash)
        detalhes = lista[chave]
        detalhes['name']       ||= commit['commit']['author']['name']
        detalhes['email']      << commit['commit']['author']['email']
        detalhes['login']      ||= commit['author'].is_a?(Hash) ? commit['author']['login'] : nil
        detalhes['avatar_url'] ||= commit['author'].is_a?(Hash) ? commit['author']['avatar_url'] : nil
        detalhes['quantidade'] += 1
        lista[chave] = detalhes
      else
        detalhes = Hash.new
        detalhes['name']       = commit['commit']['author']['name']
        detalhes['email']      = []
        detalhes['email']      << commit['commit']['author']['email']
        detalhes['login']      = commit['author'].is_a?(Hash) ? commit['author']['login'] : nil
        detalhes['avatar_url'] = commit['author'].is_a?(Hash) ? commit['author']['avatar_url'] : nil
        detalhes['quantidade'] = 1
        lista[chave] = detalhes
      end
    end
    array = []
    lista.each do |k,v|
      array << v
    end

    array = array.sort_by{|commit| commit['quantidade']}.reverse
    array
  end

  def gerar_arquivo(commits_classificados, repositorio)
    File.open("arquivos/#{repositorio}_#{data_hora_f}.txt", 'w') do |file|
      commits_classificados.each do |commit|
        file.puts "#{commit['name']};#{commit['email'].uniq.join(',')};#{commit['login']};#{commit['avatar_url']};#{commit['quantidade']}"
      end
    end
  end

  def data_hora_f
    Time.now.strftime("%d-%m-%Y_%H-%M")
  end
end
