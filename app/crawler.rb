require 'google_custom_search_api'
require 'openssl'
require 'net/http'
require 'open-uri'
require 'nokogiri'


module Crawler

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  #faz a query no google e retorna os links da pesquisa
  def self.search(query, opts = {})

    results = GoogleCustomSearchApi.search(query, opts)
    links = []
    results["items"].each do |item|
      links.push({link:item["link"], title:item["title"], snippet:item["snippet"]})
    end

    return links
  end

  #extrai documentação e o código fonte da página a partir do html
  def self.extractHTML(links)

    htmls = []

    #links.each do |link|
      puts links[0][:link]
      doc = Nokogiri::HTML(open(links[0][:link]))
      htmls.push(doc)
    #end
    return htmls
  end
end
