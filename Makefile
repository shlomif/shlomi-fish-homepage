WML_FLAGS += --passoption=2,-X3074 --passoption=3,-I../lib/ --passoption=3,-w -I../lib/ -DROOT~.

# t2 macros

include make_helpers/include.mak

ALL_DEST_BASE = dest

T2_DEST_BASE = $(ALL_DEST_BASE)
T2_DEST_DIR = t2-homepage
T2_DEST = $(T2_DEST_BASE)/$(T2_DEST_DIR)



T2_WML_FLAGS = $(WML_FLAGS) -DSERVER=t2

T2_DOCS_DEST = $(patsubst t2/%.wml,$(T2_DEST)/%,$(T2_DOCS))

T2_DIRS_DEST = $(patsubst t2/%,$(T2_DEST)/%,$(T2_DIRS))

T2_IMAGES_DEST = $(patsubst t2/%,$(T2_DEST)/%,$(T2_IMAGES))

T2_COMMON_IMAGES_DEST = $(patsubst common/%,$(T2_DEST)/%,$(COMMON_IMAGES))

T2_COMMON_DIRS_DEST = $(patsubst common/%,$(T2_DEST)/%,$(COMMON_DIRS))



# vipe macros

VIPE_DEST_BASE = $(ALL_DEST_BASE)
VIPE_DEST_DIR = vipe-homepage
VIPE_DEST = $(VIPE_DEST_BASE)/$(VIPE_DEST_DIR)

VIPE_WML_FLAGS = $(WML_FLAGS) -DSERVER=vipe

VIPE_DOCS_DEST = $(patsubst vipe/%.wml,$(VIPE_DEST)/%,$(VIPE_DOCS))

VIPE_DIRS_DEST = $(patsubst vipe/%,$(VIPE_DEST)/%,$(VIPE_DIRS))

VIPE_IMAGES_DEST = $(patsubst vipe/%,$(VIPE_DEST)/%,$(VIPE_IMAGES))

VIPE_COMMON_IMAGES_DEST = $(patsubst common/%,$(VIPE_DEST)/%,$(COMMON_IMAGES))

VIPE_COMMON_DIRS_DEST = $(patsubst common/%,$(VIPE_DEST)/%,$(COMMON_DIRS))

T2_TARGETS = $(T2_DIRS_DEST) $(T2_COMMON_DIRS_DEST) $(T2_COMMON_IMAGES_DEST) $(T2_IMAGES_DEST) $(T2_DOCS_DEST) 

VIPE_TARGETS = $(VIPE_DIRS_DEST) $(VIPE_COMMON_DIRS_DEST) $(VIPE_COMMON_IMAGES_DEST) $(VIPE_IMAGES_DEST) $(VIPE_DOCS_DEST) 

all: $(T2_TARGETS) $(VIPE_TARGETS)
#all: $(T2_DIRS_DEST) $(T2_DOCS_DEST) 

RSYNC = rsync --progress --verbose --rsh=ssh

upload_t2: $(T2_TARGETS)
	( cd $(T2_DEST) && $(RSYNC) -r * shlomif@iglu.org.il:Home-Site/ )

upload_vipe: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * shlomif@vipe.technion.ac.il:public_html/ )
	
upload: upload_t2 upload_vipe

clean:
	rm -fr $(T2_DEST)/*
	rm -fr $(VIPE_DEST)/*

DOCS_COMMON_DEPS = template.wml lib/MyNavData.pm
# t2 targets
$(T2_DOCS_DEST) :: $(T2_DEST)/% : t2/%.wml t2/.wmlrc $(DOCS_COMMON_DEPS) 
	( cd t2 && wml $(T2_WML_FLAGS) -DFILENAME=$(patsubst $(T2_DEST)/%,%,$(patsubst %.wml,%,$@)) $(patsubst t2/%,%,$<) ) > $@

$(T2_DIRS_DEST) :: $(T2_DEST)/% : unchanged
	mkdir -p $@
	touch $@

$(T2_IMAGES_DEST) :: $(T2_DEST)/% : t2/%
	cp -f $< $@

$(T2_COMMON_IMAGES_DEST) :: $(T2_DEST)/% : common/%
	cp -f $< $@

$(T2_COMMON_DIRS_DEST) :: $(T2_DEST)/% : unchanged
	mkdir -p $@
	touch $@


# vipe targets

$(VIPE_DOCS_DEST) :: $(VIPE_DEST)/% : vipe/%.wml vipe/.wmlrc $(DOCS_COMMON_DEPS)
	( cd vipe && wml $(VIPE_WML_FLAGS) -DFILENAME=$(patsubst $(VIPE_DEST)/%,%,$(patsubst %.wml,%,$@)) $(patsubst vipe/%,%,$<) ) > $@

$(VIPE_DIRS_DEST) :: $(VIPE_DEST)/% : unchanged
	mkdir -p $@
	touch $@

$(VIPE_IMAGES_DEST) :: $(VIPE_DEST)/% : vipe/%
	cp -f $< $@

$(VIPE_COMMON_IMAGES_DEST) :: $(VIPE_DEST)/% : common/%
	cp -f $< $@

$(VIPE_COMMON_DIRS_DEST) :: $(VIPE_DEST)/% : unchanged
	mkdir -p $@
	touch $@

t2/SFresume.html.wml : t2/SFresume_base.wml
	touch $@

t2/SFresume_detailed.html.wml : t2/SFresume_base.wml
	touch $@

t2/philosophy/Index/index.html.wml : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl
	touch $@

