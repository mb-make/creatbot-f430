#
# Install printer profiles from debian package
# to local prusa-slicer installation
#

URL=https://www.creatbot.com/downloads/CreatWare_7.0.2_amd64.deb
DEB=$(shell basename $(URL))
DIR_SRC=./usr/share/resources
DIR_DST=/usr/share/PrusaSlicer
SRC:=profiles/CreatResearch.ini
SRC+=profiles/CreatResearch/*
SRC+=icons/CreatWare*.png
SRC+=udev/*
DST=$(addprefix $(DIR_DST)/,$(SRC))
DIRS_DST:=profiles/CreatResearch
DIRS_DST+=icons
DIRS_DST+=udev


.PHONY: all
all: $(DST)

$(DEB):
	curl -o $@ -C - $(URL)

data.tar.zst: $(DEB)
	ar x $< $@

%.tar: %.tar.zst
	zstd -d $<

$(SRC): data.tar
	 tar --wildcards -vxf $< $(addprefix $(DIR_SRC)/,$@)

$(DIR_DST)/%: %
	@mkdir -p $(addprefix $(DIR_DST)/,$(DIRS_DST))
	cp -av $(addprefix $(DIR_SRC)/,$<) $(DIR_DST)/$(dir $<)

.PHONY: clean
clean:
	rm -vf $(DST)

