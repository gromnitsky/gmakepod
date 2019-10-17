src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk

define header :=
# auto-generated
.DELETE_ON_ERROR:
src := $(src)
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
e.curl = $(if $(catchup),$(call echo,Memorising $$@),$(or $(curl),$(.curl),curl --connect-timeout 15 -fL -C - -o $$@) $(curl.opt) $1)

define rule =
$(.name):
	@mkdir -p $$(dir $$@)
	$(call e.curl,$(call escape,$(.url)))
	$$(call history,$(call escape,$(.url)))
endef

$(info $(header))
$(info all:)$(info )

%:
	@$(props_parse_init)
	@$(call props_parse,$*)

	$(info $(rule))
	$(info all: $(if $(.convert-to),\
		$(basename $(.name))$(.convert-to),\
		$(.name)))
	$(info )
	@:
