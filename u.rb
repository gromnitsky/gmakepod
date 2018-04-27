require 'cgi'
require 'shellwords'

def norm p; CGI.unescape(p).gsub(/[^[:word:].,\/-]/, "_"); end
def escape s; s.gsub(/[!]/, ?_).gsub(/\$/, '$$').shellescape; end
def props_fmt h, kprefix
  h.map do |k, v|
    refine = method(k =~ /^\.?(url|filter)/ ? :escape : :norm)
    "#{kprefix}#{norm k.to_s}:=#{refine.call v.to_s}"
  end
end
