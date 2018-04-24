define newline


endef

conf_parse = $(eval $(subst !,$(newline),$(shell echo '$1' | awk '{print substr($$0, 2)}')))
conf_parse_init = $(call conf_parse,:.name=!.url=!.reverse=!.e=!.convert-to=)
