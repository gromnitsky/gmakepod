src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
url = $(shell echo "$1" | cut -d'!' -f2)
%:
	-@ruby $(src)/history.rb get "$(call url,$*)" > /dev/null || echo "$*"
