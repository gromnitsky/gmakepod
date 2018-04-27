src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk

curl = curl --connect-timeout 15 -fL -C - '$$1' -o $$@ $(curl.opt)

define header :=
# auto-generated
src := $(src)
e.curl = $(if $(catchup),@echo Memorising $$@ 1>&2,$(curl))
ffmpeg.mp3 = $$(src)/sh-progress-reporter/example-ffmpeg-mp3.sh $$<
%.mp3: %.m4v
	$$(ffmpeg.mp3)
	rm $$<
%.mp3: %.m4a
	$$(ffmpeg.mp3)
	rm $$<
%.mp3: %.ogg
	$$(ffmpeg.mp3)
	rm $$<
.PHONY: all
endef

escape = $(subst $,$$$$,$1)

define rule =
$(.name):
	@mkdir -p $$(dir $$@)
	$$(call e.curl,$(call escape,$(.url)))
	@ruby $$(src)/history.rb add '$(call escape,$(.url))'
endef

targets := $(foreach idx, $(MAKECMDGOALS),\
  $(conf_parse_init)\
  $(call conf_parse,$(idx))\
  $(if $(.convert-to),\
    $(basename $(.name))$(.convert-to),\
   $(.name)))

$(info $(header))
$(info all: $(targets))

%:
	@$(conf_parse_init)
	@$(call conf_parse,$*)

	$(info $(rule))
	@:
