require 'date'
require 'uri'
require 'cgi'

def simple p; File.basename p; end
def timestamp p
  File.basename(p, ".*") + "." + DateTime.now.strftime("%Q") + File.extname(p)
end

ofile = ENV['t'].to_s != '' ? method(:timestamp) : method(:simple)
def normalize p; CGI.unescape(p).gsub(/[^[:word:].,\/-]/, "_"); end

# input: foo!http://example.com/file.m4v!.mp3
# output: media/foo/file.m4v!http://example.com/file.m4v!.mp3
while (line = gets)
  name, feed, convert_to, reverse = line.split("!")
  p = normalize URI(feed).path
  puts [File.join('media', name, ofile.call(p)), feed, convert_to, reverse].join '!'
end
