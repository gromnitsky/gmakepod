require 'inifile'
require_relative 'u'

fail "Usage: #{$0} file.ini" unless ARGV[0]

def xargs_safe s; s.to_s.gsub(/[!'"]/, ?_); end

IniFile.new(content: `erb "#{File.realpath ARGV[0]}"`).to_h.map do |k,v|
  name = ".name:=#{norm(k)}"
  puts ':' + [name, *v.map{|pk, pv| ".#{xargs_safe pk}:=#{xargs_safe pv}"}]*?!
end
