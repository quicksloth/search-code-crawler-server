require 'google_custom_search_api'
require 'openssl'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'timeout'

require_relative 'htmlcode'
require_relative 'constants'
require_relative 'search_code'
require_relative 'search_result'

class Crawler

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  attr_accessor :htmlFiles, :urls, :request, :searchResult

  # class initializer
  def initialize(request)
    @htmlFiles = []
    @urls = []
    @request = request
    @searchResult = SearchResult.new
  end

  # faz a query no google e retorna os links da pesquisa
  def searchRequest(opts = {})
    results = GoogleCustomSearchApi.search(@request, opts)
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
    @urls.each do |link|
      ini = DateTime.now.strftime('%Q').to_i
      begin
        code = HTMLCode.new
        code.uri = link[:link]
        code.html = Timeout::timeout(1.2) do
          Thread.new { Nokogiri::HTML(open(link[:link])) }.value
        end
        @htmlFiles.push code
      rescue
        puts Constants.errorHTTP link[:link]
      end
      fim = DateTime.now.strftime('%Q').to_i
      puts "#{link[:link]}  Time: #{fim - ini}"
    end
    puts "HTML extraction completed."
  end

  def doCodeAndDocExtraction
    @htmlFiles.each do |html|
      # extract codes by using the code regex
      codes = html.html.to_s.scan(Constants::SOURCECODEREGEX)
      doc = ''
      if html.uri.include? "stackoverflow"
        doc = extractSODoc(html.html)
      else
        doc = extractGenericDoc(html.html)
      end

      codes.each do |code|
        searchCode = SearchCode.new
        searchCode.url = html.uri
        searchCode.documentation = doc
        searchCode.sourceCode = code

        @searchResult.searchCodes.push searchCode
      end
    end
  end

  def extractSODoc(html)
    # extract doc and clean it by using the doc regex
    doc = html.to_s.scan (Constants::STACKOVERFLOWREGEX)
    doc = doc.join"\n"
    # remove tags
    doc.to_s.gsub! Constants::TAGREGEX, ""
    # remove lines that starts with numbers
    doc.to_s.gsub! Constants::NUMBERREGEX, ""
    # remove links
    doc.to_s.gsub! Constants::LINKREGEX, ""
    # remove blank lines
    doc.to_s.gsub! Constants::BLANKLINESREGEX, "\n"
    return doc
  end

  def extractGenericDoc(html)
    # extract doc and clean it by using the doc regex
    doc = html.to_s.scan (Constants::GENERICREGEX)
    doc = doc.join"\n"
    # remove tags
    doc.to_s.gsub! Constants::TAGREGEX, ""
    # remove lines that starts with numbers
    doc.to_s.gsub! Constants::NUMBERREGEX, ""
    # remove links
    doc.to_s.gsub! Constants::LINKREGEX, ""
    # remove blank lines
    doc.to_s.gsub! Constants::BLANKLINESREGEX, "\n"
    return doc
  end
end
