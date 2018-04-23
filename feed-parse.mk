e := 2
filter.type := .
filter.url := .
g := .
rsort :=

# foo!http://example.com/rss!.mp3!true
name       = $(shell echo "$1" | cut -d'!' -f1)
url        = $(shell echo "$1" | cut -d'!' -f2)
convert-to = $(shell echo "$1" | cut -d'!' -f3)
reverse    = $(shell echo "$1" | cut -d'!' -f4)

revsort = $(if $(or $(rsort),$(call reverse,$*)),.reverse(),)

.ONESHELL:

# output: foo!http://example.com/file.mp4!.mp3!true
%:
	@echo "$(call name,$*)" | grep -Eiq "$(g)" || exit 0
	@echo Processing "$(call name,$*)" 1>&2
	@curl -sfL --connect-timeout 15 -m 60 "$(call url,$*)" | nokogiri -e '\
puts $$_.css("enclosure,link[rel=\"enclosure\"]").\
  select{|e| e["type"] ? e["type"].match(/$(filter.type)/) : true}.\
  map{|e| e["url"] || e["href"]}.\
  select{|url| url.match(/$(filter.url)/)}\
  $(revsort)[0...$(e)].\
  map{|url| ["$(call name,$*)", url, "$(call convert-to,$*)", "$(call reverse,$*)"].join "!"}'
