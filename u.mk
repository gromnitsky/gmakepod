separator := 9dcd4654-4b01-11e8-9491-000c2945132f
_hash := \#
define newline :=


endef
props_def := :{".name":"" , ".url":"" , ".reverse":"" , ".e":"" , ".convert-to":"" , ".filter.name":"" , ".filter.url":"", ".curl":""}

props_parse = $(eval $(subst $(separator),$(newline),$(shell echo $(call se,$1) | ruby -rjson --disable-gems -n -e 'puts JSON.parse($$_[1..-1]).map{|k,v| "$(_hash){k}:=$(_hash){v}"}.join("$(separator)")' )))
props_parse_init = $(call props_parse,$(props_def))
eq = $(and $(findstring x$(1),x$(2)), $(findstring x$(2),x$(1)))
echo = $(if $(findstring s,$(firstword -$(MAKEFLAGS))),,@echo $1 1>&2)
se = '$(subst ','\'',$1)'
