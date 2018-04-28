require 'cgi'
require 'shellwords'
require 'json'

def norm p; CGI.unescape(p).gsub(/[^[:word:].,\/-]/, "_"); end
def recipe_escape s; s.gsub(/\$/, '$$'); end
def recipe_unescape s; s.gsub(/\${2}/, '$'); end
def props h, kprefix
  h.map do |k, v|
    refine = method(k =~ /^\.?(url|filter)/ ? :recipe_escape : :norm)
    ["#{kprefix}#{norm k.to_s}", refine.call(v.to_s)]
  end.to_h
end
def line_parse line
  JSON.parse(line[1..-1]).transform_values {|v| recipe_unescape(v)}
end
