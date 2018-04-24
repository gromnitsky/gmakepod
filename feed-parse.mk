src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk

e :=
filter.type := .
filter.url := .
g := .
reverse :=

.ONESHELL:

# FIXME: if an ini section has `reverse=1`, user can't flip the val from the CL
%:
	@$(conf_parse_init)
	@$(call conf_parse,$*)

	@echo $(.name) | grep -Eiq '$(g)' || exit 0
	@echo Processing $(.name) 1>&2
	@curl -sfL --connect-timeout 15 -m 60 '$(.url)' | nokogiri -e '\
puts $$_.css("enclosure,link[rel=\"enclosure\"]").\
  select{|e| e["type"] ? e["type"].match(/$(filter.type)/) : true}.\
  map{|e| e["url"] || e["href"]}.\
  select{|url| url.match(/$(filter.url)/)}\
  $(if $(or $(reverse),$(.reverse)),.reverse())[0...$(or $(e),$(.e),2)].\
  map{|u| ":" + [".name:=$(.name)", ".url:=#{u}", ".convert-to:=$(.convert-to)"]*?!}'
