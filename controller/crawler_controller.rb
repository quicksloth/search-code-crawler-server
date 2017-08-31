require_relative '../model/crawler'
require 'date'
require 'json'
require 'sinatra'

def everything query, clientID
  ini = DateTime.now.strftime('%Q').to_i

  crawler = Crawler.new query, clientID
  crawler.searchRequest
  crawler.extractSourceCodeAndDoc

  f = DateTime.now.strftime('%Q').to_i

  crawler.printSearchInfo
  crawler.generateJson

  # File.open("teste.json", "w"){ |file|
  #   file.write crawler.json
  # }
  puts "-----------------------------"
  puts "Crawler tasks completed in " + ((f - ini)/1000.0).to_s + " seconds."
  return crawler.json
end

get '/' do
  "hello World"
end

get '/crawl' do
  headers ({"Content-Type" => "application/json"})
  body everything params["query"], params["id"]
end

before '/teste' do
  request.body.rewind
  @request_payload = JSON.parse request.body.read
end

get '/teste' do
  #body (params["query"] + params["id"])
end

after '/teste' do
  puts "after triggered"
end