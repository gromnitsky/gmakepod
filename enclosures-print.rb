require 'securerandom'
require 'uri'
require_relative 'u'

def filename p
  File.basename(p, ".*") + "." + SecureRandom.hex(4) + File.extname(p)
end

ARGV.each do |enclosure|
  c = line_parse enclosure
  p = URI(c['.url']).path; p = 'noname.mp3' if p.size == 0
  c['.name'] = File.join('media', c['.name'], filename(norm p))
  puts ':' + props(c, '').to_json.shellescape
end
