require_relative 'crawler'
require 'date'
require 'json'

ini = DateTime.now.strftime('%Q').to_i

crawler = Crawler.new"bubble sort java site:stackoverflow.com"
crawler.searchRequest

crawler.extractSourceCodeAndDoc

f = DateTime.now.strftime('%Q').to_i

crawler.printSearchInfo

crawler.generateJson

File.open("teste.json", "w"){ |file|
  file.write crawler.json
}





# json = {}
#
# crawler.searchResult.instance_variables.each do |var|
#   json[var] = crawler.searchResult.instance_variable_get var
#
#   json[var].each do |v|
#
#   end
# end
# puts crawler.searchResult.instance_variables
# puts "---------"
# puts json.to_json
# puts json


puts (f - ini).to_s

