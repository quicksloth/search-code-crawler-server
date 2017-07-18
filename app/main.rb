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
# crawler.htmlFiles.each do |html|
# end

regex = /<(?!pre|noscript|code|script|div|td|g)\w+>[ \w\d.,'?()<>="\/:\-_]+/
regex = /<pre>(?:<code>)?[\w\d\s.,'?()&&[^<]](?:<\/code>)?<\/pre>/
puts crawler.htmlFiles[2].html.to_s

#puts crawler.htmlFiles[2].html

f = DateTime.now.strftime('%Q').to_i

puts (f - ini).to_s

# crawler.htmlFiles.each do |file|
#   puts file.html
#   puts "---------------------------------------------"
# end




