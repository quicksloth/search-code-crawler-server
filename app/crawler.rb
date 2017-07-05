require 'google_custom_search_api'
require 'openssl'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require_relative 'htmlcode'
require_relative 'constants'


class Crawler

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  attr_accessor :htmlFiles, :urls, :request

  # class initializer
  def initialize(request)
    @htmlFiles = []
    @urls = []
    @request = request
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
    @urls.each do |link|
      begin
        code = HTMLCode.new
        code.uri = link[:link]
        code.html = Nokogiri::HTML(open(link[:link]))
        @htmlFiles.push code
      rescue
        puts Constants.errorHTTP link[:link]
      end
    end
    puts "Done"
  end
end
