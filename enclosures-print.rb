require 'securerandom'
require 'uri'
require_relative 'u'

def rnd; ENV['GMAKEPOD_TEST_SECURERANDOM'] || 2.times.map{SecureRandom.hex(4)}.join('.'); end
def filename p; File.basename(p, ".*") + "." + rnd + File.extname(p); end

ARGV.each do |enclosure|
  c = props_parse enclosure
  p = URI(c['.url']).path rescue ''; p = 'noname.mp3' if p.size == 0
  c['.name'] = File.join('media', c['.name'], filename(norm p))
  puts props(c, '').xargs
end
