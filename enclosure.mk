ofile := $(if $(t), ofile_timestamp, ofile_simple)

odir = $(shell echo "$1" | cut -f1 -d'!')
url  = $(shell echo "$1" | cut -f2 -d'!')
ofile_simple = $(shell echo "$(call url,$1)" | ruby -ruri -ne 'puts File.basename URI($$_.strip).path')
ofile_timestamp = $(shell echo "$(call url,$1)" | ruby -ruri -rdate -ne 'p=URI($$_.strip).path; puts File.basename(p, ".*") + "." + DateTime.now.strftime("%Q") + File.extname(p)')

curl = curl -L\# -C- "$1" -o "$2"

%:
	@mkdir -p "$(call odir,$*)"
	$(call curl,$(call url,$*),$(call odir,$*)/$(call $(ofile),$*))
