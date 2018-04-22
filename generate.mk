define header :=
# auto-generated
src := $(mk.root)
enclosures.curl.opt :=
enclosures.curl = curl --connect-timeout 15 -fL -C - "$$1" -o $$@ $(enclosures.curl.opt)
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

# foo/file.mp4!http://example.com/file.mp4!.mp3!true
ofile      = $(shell echo "$1" | cut -d'!' -f1)
url        = $(shell echo "$1" | cut -d'!' -f2)
convert-to = $(shell echo "$1" | cut -d'!' -f3)
reverse    = $(shell echo "$1" | cut -d'!' -f4)

define rule =
$(call ofile,$1):
	@mkdir -p $$(dir $$@)
	$$(call enclosures.curl,$(call url,$1))
	@ruby $$(src)/history.rb add "$(call url,$1)"
endef

targets := $(foreach idx, $(MAKECMDGOALS),\
  $(if $(call convert-to,$(idx)),\
    $(basename $(call ofile,$(idx)))$(call convert-to,$(idx)),\
   $(call ofile,$(idx))))

$(info $(header))
$(info all: $(targets))

%:
	$(info $(call rule,$*))
	@:
