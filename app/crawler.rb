require 'google_custom_search_api'
require 'openssl'


module Crawler

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  def self.search(query, opts = {})

    results = GoogleCustomSearchApi.search(query, opts)
    links = []

    results["items"].each do |item|
      links.push({link:item["link"], title:item["title"]})
    end

    return links
  end
end
