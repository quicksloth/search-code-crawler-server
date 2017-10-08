require 'openssl'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'timeout'
require 'json'

require_relative '../helper/constants'

class Train

  attr_accessor :nodes, :rootUrl, :docs, :urlsCount, :urlsLimit, :json, :accessedUrls

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  def initialize rootUrl, urlsLimit, pushlimit
    @rootUrl = rootUrl
    @docs = []
    @nodes = []
    @urlsLimit = urlsLimit
    @urlsCount = 0
    @accessedUrls = []
    @pushlimit = pushlimit
    @accessedUrlsFileName = "accessedurls.txt"
    readAccessedUrls
  end

  def getTrainData url = @rootUrl

    print "#" + @urlsCount.to_s
    puts " Accessing: " + @nodes[0].to_s

    html = Nokogiri::HTML(open(url))
    accessedUrls << url
    @urlsCount += 1

    # push urls into queue
    urls = html.to_s.scan(Constants::WIKIURLREGEX)
    urls.each do |url|
      @nodes << url
    end
    @nodes.uniq!

    # extract and push docs
    doc = Constants::extractGenericDoc(html)
    @docs << doc.encode('UTF-8', :replace => '',:invalid => :replace, :undef => :replace)

    # recursive call
    nextUrl = @nodes.shift
    while @accessedUrls.include?("https://en.wikipedia.org/" + nextUrl)
      nextUrl = @nodes.shift
    end

    if @urlsCount%@pushlimit == 0
      puts "coc"
      generateJson
      #postData
      writeAccessedUrls
      readAccessedUrls
    end

    if @urlsCount < @urlsLimit && urls.size != 0
      getTrainData("https://en.wikipedia.org/" + nextUrl)
    else
      generateJson
      postData
      writeAccessedUrls
      readAccessedUrls
    end
  end

  def generateJson
    h = {train_text: []}
    @docs.each do |doc|
      h[:train_text] << doc
    end
    @json = h.to_json
  end

  def postData
    uri = URI.parse("http://0.0.0.0:10443/train-network")
    data = @json
    header = {"Content-Type" => 'application/json'}
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = (data)
    http.request(request)
    puts "Post successfully made to destination with #{@pushlimit} links."
  end

  def readAccessedUrls
    urlsText = File.read(@accessedUrlsFileName)
    @accessedUrls = urlsText.split("\n")
  end

  def writeAccessedUrls
    File.open(@accessedUrlsFileName, 'w') { |f|
      @accessedUrls.each do |url|
        f.puts url
      end
    }
  end

end



# startNode = "https://en.wikipedia.org/wiki/Python_(programming_language)"
# train = Train.new( startNode, 10)
#
# train.getTrainData
#
# puts train.json


