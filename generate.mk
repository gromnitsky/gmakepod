define header :=
# auto-generated
src := $(mk.root)
enclosures.curl = curl --connect-timeout 15 -RfL -C - "$$1" -o $$@
to-mp3 = cp $$< $$@
%.mp3: %.m4v
	$$(to-mp3)
%.mp3: %.m4a
	$$(to-mp3)
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
$(info .INTERMEDIATE: $(foreach idx, $(MAKECMDGOALS),\
  $(if $(call ext,$(idx)),$(call ofile,$(idx)))))

$(info all: $(targets))

%:
	$(info $(call rule,$*))
	@:
