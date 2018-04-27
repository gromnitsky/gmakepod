src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk

g := .

opt = $(or $($1),$(.$1),$2)
opt.bool = $(if $(call eq,$1,1),$2)
.ONESHELL:

%:
	@$(conf_parse_init)
	$(call conf_parse,$*)

	echo $(.name) | grep -Eiq '$(g)' || exit 0
	$(call echo,Processing $(.name))
	curl -sfL --connect-timeout 15 -m 60 $(call se,$(.url)) $(curl.opt) | \
nokogiri -C$(src)/u.rb -e 'puts $$_.css("enclosure,link[rel=\"enclosure\"]").\
  select{|e| e["type"] ? e["type"].match(/$(call opt,filter.type,.)/) : true}.\
  map{|e| e["url"] || e["href"]}.\
  select{|url| url.match(/$(call opt,filter.url,.)/)}\
  $(call opt.bool,$(call opt,reverse),.reverse())[0...$(call opt,e,2)].\
  map{|u| ":" + [".name:=$(.name)", ".url:=#{u.shellescape}", ".convert-to:=$(.convert-to)"]*?!}'
