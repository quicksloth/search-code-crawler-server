require_relative '../model/train'
require 'date'
require 'json'
require 'nokogiri'

startNode = "https://en.wikipedia.org/wiki/Python_(programming_language)"
train = Train.new( startNode, 5)
train.getTrainData

data = train.json

# insert url here
uri = URI.parse("http://0.0.0.0:6060/train-network")
# insert url here

header = {"Content-Type" => 'application/json'}
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri, header)
request.body = (data.to_json).to_s
#request.body.force_encoding("UTF-8")
request.body
# Send the request
puts http.request(request)

puts "POST made: "
puts "\t doc count: " + train.docs.count.to_s