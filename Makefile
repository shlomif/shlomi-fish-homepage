WML_FLAGS += --passoption=2,-X -DROOT~.

# t2 macros

T2_DOCS = $(shell bash find-wmls-t2.sh)

T2_DEST_BASE = /var/www/html/shlomi/
T2_DEST_DIR = t2-homepage
T2_DEST = $(T2_DEST_BASE)$(T2_DEST_DIR)



T2_WML_FLAGS = $(WML_FLAGS) -DSERVER=t2

T2_DOCS_DEST = $(patsubst t2/%.wml,$(T2_DEST)/%,$(T2_DOCS))

T2_DIRS = $(shell find t2 -type d | grep -v '/\.svn' | grep -v '^\.svn' | tail +2)

T2_DIRS_DEST = $(patsubst t2/%,$(T2_DEST)/%,$(T2_DIRS))

T2_IMAGES = $(shell find t2 -type f -not -name '*.wml' -not -name '.*' | grep -v '/\.svn' | grep -v '~$$')

T2_IMAGES_DEST = $(patsubst t2/%,$(T2_DEST)/%,$(T2_IMAGES))

# vipe macros

VIPE_DOCS = $(shell bash find-wmls-vipe.sh)

VIPE_DEST_BASE = /var/www/html/shlomi/
VIPE_DEST_DIR = vipe-homepage
VIPE_DEST = $(VIPE_DEST_BASE)$(VIPE_DEST_DIR)

VIPE_WML_FLAGS = $(WML_FLAGS) -DSERVER=vipe

VIPE_DOCS_DEST = $(patsubst vipe/%.wml,$(VIPE_DEST)/%,$(VIPE_DOCS))

VIPE_DIRS = $(shell find vipe -type d | grep -v '/\.svn' | grep -v '^\.svn' | tail +2)

VIPE_DIRS_DEST = $(patsubst vipe/%,$(VIPE_DEST)/%,$(VIPE_DIRS))

VIPE_IMAGES = $(shell find vipe -type f -not -name '*.wml' -not -name '.*' | grep -v '/\.svn' | grep -v '~$$')

VIPE_IMAGES_DEST = $(patsubst vipe/%,$(VIPE_DEST)/%,$(VIPE_IMAGES))

T2_TARGETS = $(T2_DIRS_DEST) $(T2_DOCS_DEST) $(T2_DEST)/style.css $(T2_IMAGES_DEST)

VIPE_TARGETS = $(VIPE_DIRS_DEST) $(VIPE_DOCS_DEST) $(VIPE_DEST)/style.css $(VIPE_IMAGES_DEST)


all: $(T2_TARGETS) $(VIPE_TARGETS)
#all: $(T2_DIRS_DEST) $(T2_DOCS_DEST) 

RSYNC = rsync --progress --verbose --rsh=ssh

upload: all
	echo T2_DEST = $(T2_DEST)
	( cd $(T2_DEST) && $(RSYNC) -r * shlomif@t2.technion.ac.il:public_html/ )
	echo VIPE_DEST = $(VIPE_DEST)
	( cd $(VIPE_DEST) && $(RSYNC) -r * shlomif@vipe.technion.ac.il:public_html/ )

clean:
	rm -fr $(T2_DEST)/*
	rm -fr $(VIPE_DEST)/*

# t2 targets
$(T2_DOCS_DEST) :: $(T2_DEST)/% : t2/%.wml template.wml t2/.wmlrc
	( cd t2 && wml $(T2_WML_FLAGS) -DFILENAME=$(patsubst $(T2_DEST)/%,%,$(patsubst %.wml,%,$@)) $(patsubst t2/%,%,$<) > $@ )

$(T2_DIRS_DEST) :: $(T2_DEST)/% : unchanged
	mkdir -p $@
	touch $@

$(T2_IMAGES_DEST) :: $(T2_DEST)/% : t2/%
	cp -f $< $@

$(T2_DEST)/style.css : style.css
	cp -f $< $@

# vipe targets

$(VIPE_DOCS_DEST) :: $(VIPE_DEST)/% : vipe/%.wml template.wml vipe/.wmlrc
	( cd vipe && wml $(VIPE_WML_FLAGS) -DFILENAME=$(patsubst $(VIPE_DEST)/%,%,$(patsubst %.wml,%,$@)) $(patsubst vipe/%,%,$<) > $@ )

$(VIPE_DIRS_DEST) :: $(VIPE_DEST)/% : unchanged
	mkdir -p $@
	touch $@

$(VIPE_IMAGES_DEST) :: $(VIPE_DEST)/% : vipe/%
	cp -f $< $@

$(VIPE_DEST)/style.css : style.css
	cp -f $< $@

