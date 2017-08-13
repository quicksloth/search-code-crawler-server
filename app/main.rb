require_relative 'crawler'
require 'date'
require 'json'

ini = DateTime.now.strftime('%Q').to_i

crawler = Crawler.new"how to read a file"
crawler.searchRequest

crawler.extractSourceCodeAndDoc

f = DateTime.now.strftime('%Q').to_i

crawler.printSearchInfo

h = {searchResult: []}
crawler.searchResult.searchSites.each do |site|
  h[:searchResult].push ({ documentation: site.documentation,
                           sourceCode: site.sourceCode, url: site.url })
end

File.open("teste.txt", "w"){ |file|
  file.write ""
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

