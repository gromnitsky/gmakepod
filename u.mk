define newline


endef

conf_parse = $(eval $(subst !,$(newline),$(shell echo '$1' | awk '{print substr($$0, 2)}')))
conf_parse_init = $(call conf_parse,:.name=!.url=!.reverse=!.e=!.convert-to=)
eq = $(and $(findstring x$(1),x$(2)), $(findstring x$(2),x$(1)))
