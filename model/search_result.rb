require_relative 'search_site'

class SearchResult
  attr_accessor :searchSites, :clientID

  def initialize
    @searchSites = []
  end
end