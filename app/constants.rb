module Constants

  # Constants
  SOURCECODEREGEX = /<pre[^>]*>(?:<code[^>]*>)?(?:[^<])*/m

  # I'll leave this one here as a memory for all the suffering i've been through
  #Regex = /<(?!pre|noscript|code|script|td|div|g)\w+>[^\n]+/

  STACKOVERFLOWREGEX = /(<p>.*?<\/p>)|(<h\d>.*?<\/h\d>)|(<span class="comment-copy">.*?<\/span>)/m

  GENERICREGEX = /(<p>.*?<\/p>)|(<h\d>.*?<\/h\d>)/m

  TAGREGEX = /<[^>]*>/
  NUMBERREGEX = /^\d[^\n]*/
  LINKREGEX = /(https[^\n\s]*)/
  BLANKLINESREGEX = /[\n]+/

  # Functions
  def self.errorHTTP link
    puts "--------------------------------------------------------------"
    puts "HTTP Error"
    puts "Could not access the following url: #{link}"
    puts "--------------------------------------------------------------"
  end



end