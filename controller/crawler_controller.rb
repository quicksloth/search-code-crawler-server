require_relative '../model/crawler'
require 'date'
require 'json'
require 'sinatra'
require 'nokogiri'

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

@request_payload = ''

before '/teste' do
  puts "Request received"
  request.body.rewind
  @request_payload = request.body.read
end

get '/teste' do
  "Crawler instantiated"
end

after '/teste' do
  json = JSON.parse(@request_payload)
  data = everything(json["query"], json["id"])

  # insert url here
  uri = URI.parse("http://localhost:4567/response")
  # insert url here

  header = {"Content-Type" => 'application/json'}
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = data
  # Send the request
  http.request(request)
end

before '/' do
  puts "Request received"
end

get '/' do
  "Hello World"
end