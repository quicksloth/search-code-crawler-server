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

  puts "after started"
  json = JSON.parse(@request_payload)
  data = everything(json["query"], json["id"] )
  puts @request_payload
  # data = {
  #     "requestID": json["requestID"],
  #     'searchResult': [
  #         {
  #             'documentation': 'reading a file',
  #             'url': 'https://url.com',
  #             'sourceCode': ['import json\n']
  #         },
  #         {
  #             'documentation': 'When youre working with Python, you dont need to import a library in order to read and write files. It’s handled natively in the language, albeit in a unique manner.',
  #             'url': 'http://www.pythonforbeginners.com/files/reading-and-writing-files-in-python',
  #             'sourceCode': ['import json\n']
  #         },
  #     ],
  # }

  # insert url here
  uri = URI.parse("http://0.0.0.0:6060/source-codes")
  # insert url here

  header = {"Content-Type" => 'application/json'}
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = (data.to_json).to_s
  request.body.force_encoding("UTF-8")
  # Send the request
  http.request(request)
end