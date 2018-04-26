require 'cgi'

def norm p; CGI.unescape(p).gsub(/[^[:word:].,\/-]/, "_"); end
def xargs_safe s; s.to_s.gsub(/[!'"]/, ?_); end # FIXME
def escape s; xargs_safe(s).gsub(/\$/, '$$'); end
def props_fmt h, kprefix
  h.map do |k, v|
    refine = method(k =~ /^\.?(url|filter)/ ? :escape : :norm)
    "#{kprefix}#{norm k.to_s}:=#{refine.call v.to_s}"
  end
end
