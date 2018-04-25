require 'date'
require 'uri'
require_relative 'u'

def parse line; line[1..-1].split('!').map{|exp| exp.split(':=', 2)}.to_h; end

def timestamp p
  File.basename(p, ".*") + "." + DateTime.now.strftime("%Q") + File.extname(p)
end

while (line = gets)
  c = parse line
  p = URI(c['.url']).path; p = 'noname.noext' if p.size == 0
  c['.name'] = File.join('media', c['.name'], timestamp(norm p))
  puts ':' + c.map{|k,v| "#{k}:=#{v}"}.join('!')
end
