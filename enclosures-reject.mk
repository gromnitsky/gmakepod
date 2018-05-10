src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk
%:
	@$(call props_parse,$*)
	-@grep -qsFx $(call se,$(.url)) $(or $(GMAKEPOD_TEST_HISTORY),history.txt) || echo $(call se,$(call se,$*))
