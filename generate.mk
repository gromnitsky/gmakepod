src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk

curl = curl --connect-timeout 15 -fL -C - $$1 -o $$@ $(curl.opt)

define header :=
# auto-generated
src := $(src)
e.curl = $(if $(catchup),$(call echo,Memorising $$@),$(curl))
history = @rlock --timeout 5 history.lock -- ruby --disable-gems -e 'IO.write "history.txt", ARGV[0]+"\n", mode: "a"' $$1 2>/dev/null
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

escape = $(call se,$(subst $,$$$$,$1))

define rule =
$(.name):
	@mkdir -p $$(dir $$@)
	$$(call e.curl,$(call escape,$(.url)))
	$$(call history,$(call escape,$(.url)))
endef

targets := $(foreach idx, $(MAKECMDGOALS),\
  $(props_parse_init)\
  $(call props_parse,$(idx))\
  $(if $(.convert-to),\
    $(basename $(.name))$(.convert-to),\
   $(.name)))

$(info $(header))
$(info all: $(targets))

%:
	@$(props_parse_init)
	@$(call props_parse,$*)

	$(info $(rule))
	@:
