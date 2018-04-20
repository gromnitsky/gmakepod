define header :=
# auto-generated
to-mp3 = cp $$< $$@
%.mp3: %.m4v
	$$(to-mp3)
%.mp3: %.m4a
	$$(to-mp3)
endef

ext   = $(shell echo "$1" | cut -f1 -d'!')
ofile = $(shell echo "$1" | cut -f2 -d'!')
url   = $(shell echo "$1" | cut -f3 -d'!')

define rule =
$(call ofile,$1):
	@mkdir -p $$(dir $$@)
	echo curl $(call url,$1) > $$@
endef

targets := $(foreach idx, $(MAKECMDGOALS),\
  $(if $(call ext,$(idx)),\
    $(basename $(call ofile,$(idx)))$(call ext,$(idx)),\
   $(call ofile,$(idx))))

$(file > dl.mk,$(header))
$(file >> dl.mk,.INTERMEDIATE: $(foreach idx, $(MAKECMDGOALS),\
  $(if $(call ext,$(idx)),$(call ofile,$(idx)))))

$(file >> dl.mk,all: $(targets))

%:
	$(file >> dl.mk,$(call rule,$*))
	@:
