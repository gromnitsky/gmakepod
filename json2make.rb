require 'json'

separator = '9dcd4654-4b01-11e8-9491-000c2945132f'
puts JSON.parse(ARGV[0][1..-1]).map{|k,v| "#{k}:=#{v}"}.join(separator)
