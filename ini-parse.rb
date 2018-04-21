require 'inifile'

fail "Usage: #{$0} file.ini" unless ARGV[0]

puts IniFile.new(content: `erb "#{ARGV[0]}"`).to_h
       .map{|k,v| [k, v["url"], v["convert-to"]].join "!"}
