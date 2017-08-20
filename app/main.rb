require_relative 'crawler'
require 'date'
require 'json'

ini = DateTime.now.strftime('%Q').to_i

crawler = Crawler.new"how to read a file"
crawler.searchRequest

crawler.extractSourceCodeAndDoc

f = DateTime.now.strftime('%Q').to_i

#crawler.printSearchInfo

crawler.generateJson

File.open("teste.json", "w"){ |file|
  file.write crawler.json
}
puts "-----------------------------"
puts "Crawler tasks completed in " + ((f - ini)/1000.0).to_s + " seconds."

