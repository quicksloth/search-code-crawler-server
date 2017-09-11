require_relative '../model/train'
require 'date'
require 'json'
require 'nokogiri'


puts "###############################################"
ini = DateTime.now.strftime('%Q').to_i

if ARGV.count != 0
  limit = ARGV[0].to_i
else
  limit = 50
end

# instantiate train object
startNode = "https://en.wikipedia.org/wiki/Python_(programming_language)"
train = Train.new( startNode, limit)
train.getTrainData
data = train.json

# insert url here
uri = URI.parse("http://0.0.0.0:10443/train-network")

# make post
header = {"Content-Type" => 'application/json'}
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri, header)
request.body = (data)
request.body
response = http.request(request)

puts "POST made: "
puts "\t doc count: " + train.docs.count.to_s
fim = DateTime.now.strftime('%Q').to_i
puts "\t Total time: " + ((fim - ini)/1000).to_s + " seconds."
puts "###############################################"