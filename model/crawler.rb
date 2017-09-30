require 'google_custom_search_api'
require 'openssl'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'timeout'
require 'json'

require_relative '../model/htmlcode'
require_relative '../helper/constants'
require_relative '../model/search_site'
require_relative '../model/search_result'

class Crawler

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  attr_accessor :htmlFiles, :urls, :request, :searchResult, :json, :clientID, :language

  GoogleCustomSearchApi::GOOGLE_API_KEY = "AIzaSyCsZ0Lf9C5fm8AKcVVS1A7E--Po22nd9tg"
  GoogleCustomSearchApi::GOOGLE_SEARCH_CX = "002462067752674001808:uy9ckkkd0js"

  # class initializer
  def initialize(request, clientID, language)
    @htmlFiles = []
    @urls = []
    @request = request
    @searchResult = SearchResult.new
    @clientID = clientID
    @language = language
  end

  # faz a query no google e retorna os links da pesquisa
  def searchRequest(opts = {})
    query = @request.strip + " " + @language
    puts "Query: " + query
    results = GoogleCustomSearchApi.search(query, opts)
    results["items"].each do |item|
      @urls.push({link:item["link"], title:item["title"], snippet:item["snippet"]})
    end
  end

  # extrai documentação e o código fonte da página a partir do html
  def extractSourceCodeAndDoc
    # Extract html from the urls
    extractHTML()
    # Extract Source and Doc
    doCodeAndDocExtraction()
  end

  def extractHTML
    # access each url and extract it's html
    threads = []
    @urls.each do |link|
      threads << Thread.new{
        begin
          Timeout::timeout(Constants::TIMEOUT) do
            code = HTMLCode.new
            code.uri = link[:link]
            code.html = Nokogiri::HTML(open(link[:link]))
            Thread.current[:output] = code
          end
        rescue
          puts Constants::errorHTTP link[:link]
          Thread.current[:output] = nil
        end
      }
    end
    ini = DateTime.now.strftime('%Q').to_i
    begin
      threads.each { |thread|
        thread.join
        unless thread[:output].nil?
          @htmlFiles.push thread[:output]
        end
      }
    end
    puts "HTML extraction completed in " + ((DateTime.now.strftime('%Q').to_i - ini)/1000.0).to_s + " seconds."
  end

  def doCodeAndDocExtraction
    @htmlFiles.each do |html|

      # specific regex use
      if html.uri.include? "stackoverflow"
        doc = Constants::extractSODoc(html.html)
      else
        doc = Constants::extractGenericDoc(html.html)
      end

      # populate new result object
      searchSite = SearchSite.new
      searchSite.url = html.uri
      searchSite.documentation = doc

      # extract codes by using the code regex
      searchSite.sourceCode = html.html.to_s.scan(Constants::SOURCECODEREGEX)
      searchSite.sourceCode.each do |code|
        code.gsub! Constants::TAGREGEX, ""
      end

      # remove results with no code in it
      searchSite.sourceCode.reject! {|x| x == ""}
      if searchSite.sourceCode.size != 0
        @searchResult.searchSites.push searchSite
      end
    end
  end

  def printSearchInfo()
    @searchResult.searchSites.each do |site|
      puts "URL:" + site.url
      puts "\tCode Qty: " + site.sourceCode.size.to_s
    end
  end

  def generateJson
    h = {requestID: @clientID, searchResult: []}
    @searchResult.searchSites.each do |site|
      h[:searchResult].push ({ url: site.url,
                               documentation: site.documentation,
                               sourceCode: site.sourceCode })
    end
    puts "encoding1"
    @json = h.to_json
    encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => '',        # Use a blank for those replacements
        :universal_newline => true       # Always break lines with \n
    }
    puts "encoding2"
    @json = @json.to_s.encode(Encoding.find('ASCII'), encoding_options)
    puts @json.class
    puts "encoding3"
    @json = @json.to_hash
    puts @json.class
    puts "encoding4"
    @json = @json.to_json
    puts @json.class
  end

end

