src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk
%:
	@$(call conf_parse,$*)
	-@ruby $(src)/history.rb get '$(.url)' > /dev/null || echo '$*'
