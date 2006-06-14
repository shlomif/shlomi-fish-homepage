LATEMP_WML_FLAGS =$(shell latemp-config --wml-flags)

COMMON_PREPROC_FLAGS = -I $$HOME/conf/wml/Latemp/lib 
WML_FLAGS += --passoption=2,-X3074 --passoption=3,-I../lib/ \
	--passoption=3,-w -I../lib/ $(LATEMP_WML_FLAGS) \
	-DROOT~. -DLATEMP_THEME=css-zen-garden \
	-I $${HOME}/apps/wml

TTML_FLAGS += $(COMMON_PREPROC_FLAGS) -I lib
WML_FLAGS += $(COMMON_PREPROC_FLAGS)

ALL_DEST_BASE = dest

FORTUNES_TARGET = dest/vipe-homepage/humour/fortunes/fortunes-index.html

DOCS_COMMON_DEPS = template.wml lib/MyNavData.pm

all: latemp_targets $(FORTUNES_TARGET) sitemap_targets
	
include include.mak
include rules.mak

# t2 macros

RSYNC = rsync --progress --verbose --rsh=ssh

upload_t2: $(T2_TARGETS)
	( cd $(T2_DEST) && $(RSYNC) -r * $${HOMEPAGE_SSH_PATH}/ )

upload_vipe: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * shlomif@vipe.technion.ac.il:public_html/ )

upload_t2_temp: $(T2_TARGETS)
	( cd $(T2_DEST) && $(RSYNC) -r * shlomif@iglu.org.il:Home-Site/__New-Site/shlomif/ )

upload_vipe_temp: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * shlomif@iglu.org.il:Home-Site/__New-Site/vipe/ )

upload_vipe_alt: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * $${HOMEPAGE_SSH_PATH}/Vipe/ )

# upload: upload_t2_temp upload_vipe_temp
upload: upload_t2 upload_vipe_alt

clean:
	rm -fr $(T2_DEST)/*
	rm -fr $(VIPE_DEST)/*

t2/SFresume.html.wml : lib/SFresume_base.wml
	touch $@

t2/SFresume_detailed.html.wml : lib/SFresume_base.wml
	touch $@

SECTION_MENU_DEPS = lib/Shlomif/Homepage/SectionMenu.pm
PHILOSOPHY_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Essays.pm
LECTURES_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Lectures.pm
SOFTWARE_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Software.pm
HUMOUR_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Humour.pm

t2/philosophy/Index/index.html.wml : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl $(PHILOSOPHY_DEPS)
	touch $@

$(FORTUNES_TARGET): vipe/humour/fortunes/fortunes-index.html.wml $(DOCS_COMMON_DEPS) $(HUMOUR_DEPS)
	( cd vipe && wml $(WML_FLAGS) -DLATEMP_SERVER=vipe -DLATEMP_FILENAME=humour/fortunes/index.html humour/fortunes/fortunes-index.html.wml ) > $@

T2_DOCS_SRC = $(patsubst $(T2_DEST)/%,$(T2_SRC_DIR)/%.wml,$(T2_DOCS_DEST))
VIPE_DOCS_SRC = $(patsubst $(VIPE_DEST)/%,$(VIPE_SRC_DIR)/%.wml,$(VIPE_DOCS_DEST))

T2_PHILOSOPHY_DOCS_SRC = $(filter-out $(T2_SRC_DIR)/philosophy/Index/%,$(filter $(T2_SRC_DIR)/philosophy/%,$(T2_DOCS_SRC)))

$(T2_PHILOSOPHY_DOCS_SRC):: $(T2_SRC_DIR)/philosophy/%.html.wml: $(PHILOSOPHY_DEPS)
	touch $@

T2_LECTURES_DOCS_SRC = $(filter $(T2_SRC_DIR)/lecture/%,$(T2_DOCS_SRC))

$(T2_LECTURES_DOCS_SRC):: $(T2_SRC_DIR)/lecture/%.html.wml: $(LECTURES_DEPS)
	touch $@

VIPE_LECTURES_DOCS_SRC = $(filter $(VIPE_SRC_DIR)/lecture/%,$(VIPE_DOCS_SRC))

$(VIPE_LECTURES_DOCS_SRC):: $(VIPE_SRC_DIR)/lecture/%.html.wml: $(LECTURES_DEPS)
	touch $@

COMMON_LECTURES_DOCS_SRC = $(patsubst %,common/%.wml,$(filter lecture/%,$(COMMON_DOCS)))

$(COMMON_LECTURES_DOCS_SRC):: common/lecture/%.html.wml: $(LECTURES_DEPS)
	touch $@

T2_SOFTWARE_DOCS_SRC = $(filter $(T2_SRC_DIR)/open-source/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/jmikmod/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/grad-fu/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/no-ie/%,$(T2_DOCS_SRC))

$(T2_SOFTWARE_DOCS_SRC):: $(T2_SRC_DIR)/%.html.wml: $(SOFTWARE_DEPS)
	touch $@

VIPE_SOFTWARE_DOCS_SRC = $(filter $(VIPE_SRC_DIR)/rwlock/%,$(VIPE_DOCS_SRC)) \
						 $(filter $(VIPE_SRC_DIR)/software-tools/%,$(VIPE_DOCS_SRC))

$(VIPE_SOFTWARE_DOCS_SRC):: $(VIPE_SRC_DIR)/%.html.wml: $(SOFTWARE_DEPS)
	touch $@


#### Humour thing

T2_HUMOUR_DOCS_SRC = $(filter $(T2_SRC_DIR)/humour/%,$(T2_DOCS_SRC)) \
					 $(filter $(T2_SRC_DIR)/humour.html.wml,$(T2_DOCS_SRC)) \
					 $(filter $(T2_SRC_DIR)/wysiwyt.html.wml,$(T2_DOCS_SRC)) \
					 $(filter $(T2_SRC_DIR)/wonderous.html.wml,$(T2_DOCS_SRC))

$(T2_HUMOUR_DOCS_SRC):: $(T2_SRC_DIR)/%.html.wml: $(HUMOUR_DEPS)
	touch $@

VIPE_HUMOUR_DOCS_SRC = $(filter $(VIPE_SRC_DIR)/humour/%,$(VIPE_DOCS_SRC))

$(VIPE_HUMOUR_DOCS_SRC):: $(VIPE_SRC_DIR)/%.html.wml: $(HUMOUR_DEPS)
	touch $@

rss:
	./bin/fetch-shlomif_hsite-feed.pl
	touch t2/index.html.wml
	touch t2/old-news.html.wml

T2_SITEMAP_FILE = $(T2_DEST)/sitemap.xml.gz

sitemap_targets: $(T2_SITEMAP_FILE)

$(T2_SITEMAP_FILE): bin/gen-google-site-map.pl
	$<

%.show:
	@echo "$* = $($*)"
