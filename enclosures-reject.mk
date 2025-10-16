src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk
history = $(or $(GMAKEPOD_TEST_HISTORY),history.txt)
grep = grep -qsFx $(call se,$(.url)) $(history)
grep-ignore-url-query = grep -qsF $(call se,$(shell echo "$(.url)" | sed 's/\?.*//')) $(history)
%:
	@$(call props_parse,$*)
	-@$(if $(.ignore-url-query),$(grep-ignore-url-query),$(grep)) || echo $(call se,$(call se,$*))
