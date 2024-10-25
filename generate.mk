src := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include $(src)/u.mk

define header :=
# auto-generated
.DELETE_ON_ERROR:
comma := ,
src := $(src)
history = @$(if $(call eq,$(j),1),,rlock --timeout 5 history.lock -- )ruby --disable-gems -e 'IO.write "history.txt", ARGV[0]+"\n", mode: "a"' $$1
ffmpeg := $$(src)/sh-progress-reporter/example-ffmpeg.sh
%.mp3: %.m4v
	$$(ffmpeg) -i $$< -vn $$@
	rm $$<
%.mp3: %.m4a
	$$(ffmpeg) -i $$< -vn $$@
	rm $$<
%.m4a: %.mp3
	$$(ffmpeg) -i $$< -c:a aac -vn $$@
	rm $$<
%.mp3: %.ogg
	$$(ffmpeg) -i $$< -vn $$@
	rm $$<
%.ogg: %.mp3
	$$(ffmpeg) -i $$< -vn $$@
	rm $$<
%.ultrafast.mp3: %.mp3
	$$(ffmpeg) -i $$< -vn -c:a libmp3lame -qscale:a 8 $$@
	rm $$<
.PHONY: all
endef

comma := ,
escape-commas = $(subst $(comma),$$(comma),$1)
escape = $(call escape-commas,$(call se,$(subst $,$$$$,$1)))
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
