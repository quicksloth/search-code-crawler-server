require_relative 'crawler'

links = Crawler.search("how to read a file ruby")
htmls = Crawler.extractHTML(links)

h = htmls[0].to_s
start = h.index('<pre>')
finish = h.index('</pre>')
v = []
while start != nil && finish != nil
  v.push h[start..finish + 5]

  h = h[finish + 5..h.size]

  start = h.index('<pre>')
  finish = h.index('</pre>')

end

puts v[1]



