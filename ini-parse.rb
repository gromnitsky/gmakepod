require 'inifile'
require_relative 'u'

IniFile.new(content: `erb "#{File.realpath ARGV[0]}"`).to_h.map do |k,v|
  puts ':' + {".name" => norm(k)}.merge(props(v, '.')).to_json.shellescape
end
