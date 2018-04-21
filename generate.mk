define header :=
# auto-generated
src := $(mk.root)
enclosures.curl.opt :=
enclosures.curl = curl --connect-timeout 15 -RfL -C - "$$1" -o $$@ $(enclosures.curl.opt)
ffmpeg.mp3 = $$(src)/sh-progress-reporter/example-ffmpeg-mp3.sh $$<
%.mp3: %.m4v
	$$(ffmpeg.mp3)
%.mp3: %.m4a
	$$(ffmpeg.mp3)
%.mp3: %.ogg
	$$(ffmpeg.mp3)
.PHONY: all
endef

# foo/file.mp4!http://example.com/file.mp4!.mp3
ofile = $(word 1,$(subst !, ,$1))
url   = $(word 2,$(subst !, ,$1))
ext   = $(word 3,$(subst !, ,$1))

define rule =
$(call ofile,$1):
	@mkdir -p $$(dir $$@)
	$$(call enclosures.curl,$(call url,$1))
	@ruby $$(src)/history.rb add "$(call url,$1)"
endef

targets := $(foreach idx, $(MAKECMDGOALS),\
  $(if $(call ext,$(idx)),\
    $(basename $(call ofile,$(idx)))$(call ext,$(idx)),\
   $(call ofile,$(idx))))

$(info $(header))
# calculate intermediate targets
convertible = $(shell [ -z "$1" ] || ([ "$1" != "$2" ] && echo true))
$(info .INTERMEDIATE: $(foreach idx, $(MAKECMDGOALS),\
  $(if $(call convertible,$(call ext,$(idx)),$(suffix $(call ofile,$(idx)))),\
    $(call ofile,$(idx)))))

$(info all: $(targets))

%:
	$(info $(call rule,$*))
	@:
