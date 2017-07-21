require_relative 'crawler'
require 'date'

ini = DateTime.now.strftime('%Q').to_i

crawler = Crawler.new"how to read a file"
crawler.searchRequest
links = crawler.urls

links.each do |link|
  puts link[:link]
end

crawler.extractSourceCodeAndDoc
puts "s " + crawler.searchResult.searchCodes.size.to_s
crawler.searchResult.searchCodes.each do |s, index|
  puts s.documentation
  puts "-----------------------------"
end

#puts crawler.htmlFiles[1].html

#puts crawler.searchResult.searchCodes.size
# crawler.htmlFiles.each do |html|
# end


#puts crawler.htmlFiles[2].html

f = DateTime.now.strftime('%Q').to_i

puts (f - ini).to_s

# crawler.htmlFiles.each do |file|
#   puts file.html
#   puts "---------------------------------------------"
# end




