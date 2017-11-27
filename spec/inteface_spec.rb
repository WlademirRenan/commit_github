# encoding: utf-8

require 'spec_helper'
require_relative '../interface'

describe Interface do
  before :each do
    @interface = Interface.new
    @retorno = {"sha"=>"a4ec1d525cc8507c635b0b811bac7b30a5565258", "commit"=>{"author"=>{"name"=>"Wlademir Renan dos Santos", "email"=>"wlademir.renan@gmail.com", "date"=>"2016-10-22T06:22:42Z"}, "committer"=>{"name"=>"Wlademir Renan dos Santos", "email"=>"wlademir.renan@gmail.com", "date"=>"2016-10-22T06:22:42Z"}, "message"=>"Ajustando menu", "tree"=>{"sha"=>"b53bebf374f79c22cf2a1fff189d615b201cd69d", "url"=>"https://api.github.com/repos/WlademirRenan/sistema_base_adminlte_2016/git/trees/b53bebf374f79c22cf2a1fff189d615b201cd69d"}, "url"=>"https://api.github.com/repos/WlademirRenan/sistema_base_adminlte_2016/git/commits/a4ec1d525cc8507c635b0b811bac7b30a5565258", "comment_count"=>0, "verification"=>{"verified"=>false, "reason"=>"unsigned", "signature"=>nil, "payload"=>nil}}, "url"=>"https://api.github.com/repos/WlademirRenan/sistema_base_adminlte_2016/commits/a4ec1d525cc8507c635b0b811bac7b30a5565258", "html_url"=>"https://github.com/WlademirRenan/sistema_base_adminlte_2016/commit/a4ec1d525cc8507c635b0b811bac7b30a5565258", "comments_url"=>"https://api.github.com/repos/WlademirRenan/sistema_base_adminlte_2016/commits/a4ec1d525cc8507c635b0b811bac7b30a5565258/comments", "author"=>{"login"=>"WlademirRenan", "id"=>16175543, "avatar_url"=>"https://avatars2.githubusercontent.com/u/16175543?v=4", "gravatar_id"=>"", "url"=>"https://api.github.com/users/WlademirRenan", "html_url"=>"https://github.com/WlademirRenan", "followers_url"=>"https://api.github.com/users/WlademirRenan/followers", "following_url"=>"https://api.github.com/users/WlademirRenan/following{/other_user}", "gists_url"=>"https://api.github.com/users/WlademirRenan/gists{/gist_id}", "starred_url"=>"https://api.github.com/users/WlademirRenan/starred{/owner}{/repo}", "subscriptions_url"=>"https://api.github.com/users/WlademirRenan/subscriptions", "organizations_url"=>"https://api.github.com/users/WlademirRenan/orgs", "repos_url"=>"https://api.github.com/users/WlademirRenan/repos", "events_url"=>"https://api.github.com/users/WlademirRenan/events{/privacy}", "received_events_url"=>"https://api.github.com/users/WlademirRenan/received_events", "type"=>"User", "site_admin"=>false}, "committer"=>{"login"=>"WlademirRenan", "id"=>16175543, "avatar_url"=>"https://avatars2.githubusercontent.com/u/16175543?v=4", "gravatar_id"=>"", "url"=>"https://api.github.com/users/WlademirRenan", "html_url"=>"https://github.com/WlademirRenan", "followers_url"=>"https://api.github.com/users/WlademirRenan/followers", "following_url"=>"https://api.github.com/users/WlademirRenan/following{/other_user}", "gists_url"=>"https://api.github.com/users/WlademirRenan/gists{/gist_id}", "starred_url"=>"https://api.github.com/users/WlademirRenan/starred{/owner}{/repo}", "subscriptions_url"=>"https://api.github.com/users/WlademirRenan/subscriptions", "organizations_url"=>"https://api.github.com/users/WlademirRenan/orgs", "repos_url"=>"https://api.github.com/users/WlademirRenan/repos", "events_url"=>"https://api.github.com/users/WlademirRenan/events{/privacy}", "received_events_url"=>"https://api.github.com/users/WlademirRenan/received_events", "type"=>"User", "site_admin"=>false}, "parents"=>[{"sha"=>"20b3d310c4991af791321735f8bdb8a8b8e0de5d", "url"=>"https://api.github.com/repos/WlademirRenan/sistema_base_adminlte_2016/commits/20b3d310c4991af791321735f8bdb8a8b8e0de5d", "html_url"=>"https://github.com/WlademirRenan/sistema_base_adminlte_2016/commit/20b3d310c4991af791321735f8bdb8a8b8e0de5d"}]}
  end

  it 'deve retornar data e hora formatados' do
    data_hora_f = @interface.data_hora_f
    expect(data_hora_f).to eq Time.now.strftime('%d-%m-%Y_%H-%M')
  end

  it 'deve retornar primeira linha igual a variavel @retorno' do
    retorno = @interface.http_get('WlademirRenan', 'sistema_base_adminlte_2016')
    expect(retorno.first).to eq @retorno
  end

  it 'deve retornar commits_classificados' do
    conteudo = [@retorno, @retorno]
    retorno = @interface.classificar_commits(conteudo)
    expect(retorno).to eq [{"name"=>"Wlademir Renan dos Santos", "email"=>["wlademir.renan@gmail.com", "wlademir.renan@gmail.com"], "login"=>"WlademirRenan", "avatar_url"=>"https://avatars2.githubusercontent.com/u/16175543?v=4", "quantidade"=>2}]
  end

  it 'deve gerar arquivo com commits classificados' do
    commits = [{"name"=>"Wlademir Renan dos Santos", "email"=>["wlademir.renan@gmail.com"], "login"=>"WlademirRenan", "avatar_url"=>"https://avatars2.githubusercontent.com/u/16175543?v=4", "quantidade"=>2}]
    @interface.gerar_arquivo(commits, 'teste')
    expect(File.exist?("arquivos/teste_#{@interface.data_hora_f}.txt")).to eq true
  end

  it 'deve buscar os commits e criar aquivo com eles classificados' do
    @interface.buscar_commits('https://github.com/Dinda-com-br/braspag-rest')
    expect(File.exist?("arquivos/braspag-rest_#{@interface.data_hora_f}.txt")).to eq true
  end
end
