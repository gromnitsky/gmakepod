require 'inifile'
require_relative 'u'

fail "Usage: #{$0} file.ini" unless ARGV[0]

IniFile.new(content: `erb "#{File.realpath ARGV[0]}"`).to_h.map do |k,v|
  name = ".name:=#{norm(k)}"
  puts ':' + [name, *props_fmt(v, '.')].join('!')
end
