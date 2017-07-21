module Constants

  # Constants
  SourceCodeRegex = /<pre[^>]*>(?:<code[^>]*>)?(?:[^<])*/m
  DocRegex = /<(?!pre|noscript|code|script|td|div|g)\w+>[^\n]+/
  DocCleanerRegex1 = /<[^>]*>/
  DocCleanerRegex2 = /^\d[^\n]*/
  DocCleanerRegex3 = /^(https?[^\n]*)/

  # Functions
  def self.errorHTTP link
    puts "--------------------------------------------------------------"
    puts "HTTP Error"
    puts "Could not access the following url: #{link}"
    puts "--------------------------------------------------------------"
  end



end