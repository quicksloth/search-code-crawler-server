require_relative '../model/crawler'
require 'date'
require 'json'
require 'sinatra'
require 'nokogiri'

get '/' do
  text = "Hello world"
  puts text
  return text
end

def everything query, clientID, language

  ini = DateTime.now.strftime('%Q').to_i

  crawler = Crawler.new query, clientID, language
  crawler.searchRequest
  crawler.extractSourceCodeAndDoc

  f = DateTime.now.strftime('%Q').to_i

  crawler.printSearchInfo
  crawler.generateJson

  puts "-----------------------------"
  puts "Crawler tasks completed in " + ((f - ini)/1000.0).to_s + " seconds."
  return crawler.json
end

@request_payload = ''

before '/crawl' do
  puts "Request received"
  request.body.rewind
  @request_payload = request.body.read
end

get '/crawl' do
  "Crawler instantiated"
end

after '/crawl' do

  puts "###############################################"
  puts "Crawler started"
  json = JSON.parse(@request_payload)
  data = everything(json["query"], json["requestID"], json["language"])

  # insert url here
  uri = URI.parse("http://0.0.0.0:10443/source-codes")
  # insert url here

  header = {"Content-Type" => 'application/json'}
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = data
  # Send the request
  puts "aqui ---------------------------------------"
  http.request(request)
  puts "POST done"
  puts "###############################################"
end