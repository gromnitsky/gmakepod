require 'date'
require 'uri'

def simple p; File.basename p; end
def timestamp p
  File.basename(p, ".*") + "." + DateTime.now.strftime("%Q") + File.extname(p)
end

ofile = ENV['timestamp'] == 1 ? method(:timestamp) : method(:simple)

# should print: foo/file.m4v!http://example.com/file.m4v!.mp3
while (line = gets)
  name, feed, ext = line.split("!")
  p = URI(feed).path
  puts [File.join('media', name, ofile.call(p)), feed, ext].join '!'
end
