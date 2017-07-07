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

puts crawler.searchResult.searchCodes[1].sourceCode
#puts crawler.htmlFiles[0].html

f = DateTime.now.strftime('%Q').to_i

puts (f - ini).to_s

# crawler.htmlFiles.each do |file|
#   puts file.html
#   puts "---------------------------------------------"
# end

# v = []
#
# htmls.each do |html|
#   h = html.to_s
#   start = h.index('<pre>')
#   finish = h.index('</pre>')
#   while start != nil && finish != nil
#     v.push h[start..finish + 5]
#     h = h[finish + 5..h.size]
#     start = h.index('<pre>')
#     finish = h.index('</pre>')
#   end
# end
#
# f = DateTime.now.strftime('%Q').to_i
#
# puts (f - ini).to_s
#
# v.each do |a|
#   puts a
# end




