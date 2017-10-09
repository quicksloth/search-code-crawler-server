require_relative '../model/train'
require 'date'
require 'json'
require 'nokogiri'


puts "###############################################"
ini = DateTime.now.strftime('%Q').to_i

if ARGV.count == 2
  limit = ARGV[0].to_i
  pushLimit = ARGV[1].to_i
else
  limit = 50
  pushLimit = 50
end

# instantiate train object
startNode = "https://en.wikipedia.org/wiki/Python_(programming_language)"
train = Train.new( startNode, limit, pushLimit)
train.getTrainData

# make post


puts "Training data gattered: "
fim = DateTime.now.strftime('%Q').to_i
puts "\t Total time: " + ((fim - ini)/1000).to_s + " seconds."
puts "###############################################"