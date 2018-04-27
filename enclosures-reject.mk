src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk
%:
	@$(call conf_parse,$*)
	-@ruby $(src)/history.rb get $(call se,$(.url)) > /dev/null || echo $(call se,$(call se,$*))
