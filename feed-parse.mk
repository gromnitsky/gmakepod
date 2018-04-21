e := 2
override reverse := $(if $(reverse),.reverse(),)
filter.type := .
filter.url := .
filter.name := .

# foo!http://example.com/rss!.mp3
name = $(word 1,$(subst !, ,$1))
url  = $(word 2,$(subst !, ,$1))
ext  = $(word 3,$(subst !, ,$1))

.ONESHELL:

# output: foo!http://example.com/file.mp4!.mp3
%:
	@echo "$(call name,$*)" | grep -Eiq "$(filter.name)" || exit 0
	@curl -sfL --connect-timeout 15 -m 60 "$(call url,$*)" | nokogiri -e '\
puts $$_.css("enclosure,link[rel=\"enclosure\"]").\
  select{|e| e["type"] ? e["type"].match(/$(filter.type)/) : true}.\
  map{|e| e["url"] || e["href"]}.\
  select{|url| url.match(/$(filter.url)/)}\
  $(reverse)[0...$(e)].\
  map{|url| ["$(call name,$*)", url, "$(call ext,$*)"].join "!"}'
