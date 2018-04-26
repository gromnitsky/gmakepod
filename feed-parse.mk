src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk

e :=
reverse :=
filter.type :=
filter.url :=
# CL only
g := .

opt = $(or $($1),$(.$1),$2)

.ONESHELL:

# FIXME: if an ini section has `reverse=1`, user can't flip the val from the CL
%:
	@$(conf_parse_init)
	@$(call conf_parse,$*)

	@echo $(.name) | grep -Eiq '$(g)' || exit 0
	@echo Processing $(.name) 1>&2
	@curl -sfL --connect-timeout 15 -m 60 '$(.url)' | nokogiri -e '\
puts $$_.css("enclosure,link[rel=\"enclosure\"]").\
  select{|e| e["type"] ? e["type"].match(/$(call opt,filter.type,.)/) : true}.\
  map{|e| e["url"] || e["href"]}.\
  select{|url| url.match(/$(call opt,filter.url,.)/)}\
  $(if $(call opt,reverse),.reverse())[0...$(call opt,e,2)].\
  map{|u| ":" + [".name:=$(.name)", ".url:=#{u}", ".convert-to:=$(.convert-to)"]*?!}'
