require 'date'
require 'uri'
require_relative 'u'

def parse line; line[1..-1].split('!').map{|exp| exp.split(':=', 2)}.to_h; end

def simple p; File.basename p; end
def timestamp p
  File.basename(p, ".*") + "." + DateTime.now.strftime("%Q") + File.extname(p)
end

ofile = ENV['t'].to_s != '' ? method(:timestamp) : method(:simple)

while (line = gets)
  c = parse line
  c['.name'] = File.join('media', c['.name'], ofile.call(norm URI(c['.url']).path))
  puts ':' + c.map{|k,v| "#{k}:=#{v}"}.join('!')
end
