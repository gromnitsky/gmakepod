n := 2
override reverse := $(if $(reverse),.reverse(),)
filter.type := .
filter.url := .

%:
	@curl -sL "$*" | nokogiri -e 'puts \
$$_.css("enclosure,link[rel=\"enclosure\"]").\
  select{|e| e["type"] ? e["type"].match(/$(filter.type)/) : true}.\
  map{|e| e["url"] || e["href"]}.\
  select{|url| url.match(/$(filter.url)/)}\
  $(reverse)[0...$(n)]'
