src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
separator := 9dcd4654-4b01-11e8-9491-000c2945132f
define newline :=


endef
comma := ,

se = '$(subst ','\'',$(1))'
#'# emacs font-lock
props_parse = $(eval $(subst $(separator),$(newline),$(shell echo $(call se,$1) | ruby -rjson -n -e 'puts JSON.parse($$_[1..-1]).map{|k,v| "\#{k}:=\#{v}"}.join("$(separator)")' )))
props_parse_init = $(call props_parse,:{".name": ""$(comma) ".url": ""$(comma) ".reverse": ""$(comma) ".e": ""$(comma) ".convert-to": ""$(comma) ".filter.name": ""$(comma) ".filter.url": ""})
eq = $(and $(findstring x$(1),x$(2)), $(findstring x$(2),x$(1)))
echo = $(if $(findstring s,$(firstword -$(MAKEFLAGS))),,@echo $1 1>&2)
