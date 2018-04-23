require 'inifile'
require_relative 'u'

fail "Usage: #{$0} file.ini" unless ARGV[0]

puts IniFile.new(content: `erb "#{File.realpath ARGV[0]}"`).to_h
       .map{|k,v| [norm(k), v["url"], v["convert-to"], v["reverse"]].join "!"}
