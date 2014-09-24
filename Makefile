LATEMP_WML_FLAGS =$(shell latemp-config --wml-flags)

WML_FLAGS += --passoption=2,-X3074 --passoption=3,-I../lib/ \
	--passoption=3,-w -I../lib/ $(LATEMP_WML_FLAGS) \
	-DROOT~. -DLATEMP_THEME=better-scm

ALL_DEST_BASE = dest

DOCS_COMMON_DEPS = template.wml lib/MyNavData.pm

all: latemp_targets

include include.mak
include rules.mak

# t2 macros

RSYNC = rsync --progress --verbose --rsh=ssh --inplace

upload_t2: $(T2_TARGETS)
	( cd $(T2_DEST) && $(RSYNC) -a * hostgator:domains/old-2005-site-t2.shlomifish.org )

upload_vipe: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -a * hostgator:domains/old-2005-site-vipe )

upload_t2_temp: $(T2_TARGETS)
	( cd $(T2_DEST) && $(RSYNC) -a * shlomif@iglu.org.il:Home-Site/__New-Site/shlomif/ )

upload_vipe_temp: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -a * shlomif@iglu.org.il:Home-Site/__New-Site/vipe/ )

# upload: upload_t2_temp upload_vipe_temp
upload: upload_t2 upload_vipe

clean:
	rm -fr $(T2_DEST)/*
	rm -fr $(VIPE_DEST)/*

t2/SFresume.html.wml : lib/SFresume_base.wml
	touch $@

t2/SFresume_detailed.html.wml : lib/SFresume_base.wml
	touch $@

t2/philosophy/Index/index.html.wml : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl
	touch $@

