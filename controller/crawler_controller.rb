require_relative '../model/crawler'
require 'date'
require 'json'
require 'sinatra'

def everything
  ini = DateTime.now.strftime('%Q').to_i

  crawler = Crawler.new"How to read a file"
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
  headers ({"Content-Type" => "application/json"})
  everything
end