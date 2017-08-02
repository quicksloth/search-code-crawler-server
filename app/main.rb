require_relative 'crawler'
require 'date'
require 'json'

ini = DateTime.now.strftime('%Q').to_i

crawler = Crawler.new"how to read a file"
crawler.searchRequest

crawler.extractSourceCodeAndDoc
puts "Code Qty: " + crawler.searchResult.searchCodes.size.to_s


f = DateTime.now.strftime('%Q').to_i


hash = {}
crawler.searchResult.instance_variables.each do |var|
  hash[var] = crawler.searchResult.instance_variable_get var
  puts hash[var][0].url

end

puts "---------"
puts hash.to_json
puts hash


puts (f - ini).to_s

