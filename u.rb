require 'cgi'

def norm p; CGI.unescape(p).gsub(/[^[:word:].,\/-]/, "_"); end
