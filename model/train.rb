require 'openssl'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'timeout'
require 'json'
require 'iconv'

require_relative '../helper/constants'

class Train

  attr_accessor :nodes, :rootUrl, :docs, :urlsCount, :urlsLimit, :json

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  def initialize rootUrl, urlsLimit
    @rootUrl = rootUrl
    @docs = []
    @nodes = []
    @urlsLimit = urlsLimit
    @urlsCount = 0
  end

  def getTrainData url = @rootUrl
    print "#" + @urlsCount.to_s
    puts " Accessing: " + @nodes[0].to_s
    html = Nokogiri::HTML(open(url))
    @urlsCount += 1

    # push urls into queue
    urls = html.to_s.scan(Constants::WIKIURLREGEX)
    urls.each do |url|
      @nodes << url
    end
    @nodes.uniq!

    # extract and push docs
    doc = Constants::extractGenericDoc(html)
    @docs << doc

    # recursive call
    if @urlsCount < @urlsLimit && urls.size != 0
      getTrainData("https://en.wikipedia.org/" + @nodes.shift)
    else
      generateJson
    end
  end

  def generateJson
    h = {train_text: []}
    @docs.each do |doc|
      h[:train_text] << doc
    end
    @json = h.to_json
  end

end

# startNode = "https://en.wikipedia.org/wiki/Python_(programming_language)"
# train = Train.new( startNode, 10)
#
# train.getTrainData
#
# puts train.json


