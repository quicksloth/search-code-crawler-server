require_relative 'search_code'

class SearchResult
  attr_accessor :searchCodes, :clientID

  def initialize
    @searchCodes = []
  end
end