LATEMP_WML_FLAGS =$(shell latemp-config --wml-flags)

COMMON_PREPROC_FLAGS = -I $$HOME/conf/wml/Latemp/lib 
WML_FLAGS += --passoption=2,-X3074 --passoption=3,-I../lib/ \
	--passoption=3,-w -I../lib/ $(LATEMP_WML_FLAGS) \
	-DROOT~. -DLATEMP_THEME=better-scm \
	-I $${HOME}/apps/wml

TTML_FLAGS += $(COMMON_PREPROC_FLAGS) -I lib
WML_FLAGS += $(COMMON_PREPROC_FLAGS)

ALL_DEST_BASE = dest

FORTUNES_TARGET = dest/t2-homepage/humour/fortunes/index.html

DOCS_COMMON_DEPS = template.wml lib/MyNavData.pm

all: latemp_targets $(FORTUNES_TARGET) sitemap_targets copy_fortunes
	
include include.mak
include rules.mak

# t2 macros

RSYNC = rsync --progress --verbose --rsh=ssh

FORTUNES_DIR = humour/fortunes

copy_fortunes:
	cp -f t2/$(FORTUNES_DIR)/fortunes-shlomif-*.tar.gz $(T2_DEST)/$(FORTUNES_DIR)

upload_deps: $(T2_TARGETS) copy_fortunes

upload_t2: upload_deps
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
upload: upload_t2

upload_backup: upload_deps
	( cd $(T2_DEST) && $(RSYNC) -r * shlomif@alberni.textdrive.com:domains/www-backup.shlomifish.org/web/public )

upload_all: upload_t2 upload_vipe_alt

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
PUZZLES_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Puzzles.pm

t2/philosophy/Index/index.html.wml : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl $(PHILOSOPHY_DEPS)
	touch $@

$(FORTUNES_TARGET): t2/humour/fortunes/fortunes-index.html.wml $(DOCS_COMMON_DEPS) $(HUMOUR_DEPS) t2/humour/fortunes/Makefile
	( cd t2 && wml $(WML_FLAGS) -DLATEMP_SERVER=t2 -DLATEMP_FILENAME=humour/fortunes/index.html -DPACKAGE_BASE="$$( unset MAKELEVEL ; cd humour/fortunes && make print_package_base )" humour/fortunes/fortunes-index.html.wml ) > $@

T2_DOCS_SRC = $(patsubst $(T2_DEST)/%,$(T2_SRC_DIR)/%.wml,$(T2_DOCS_DEST))
VIPE_DOCS_SRC = $(patsubst $(VIPE_DEST)/%,$(VIPE_SRC_DIR)/%.wml,$(VIPE_DOCS_DEST))

T2_PHILOSOPHY_DOCS_SRC = $(filter-out $(T2_SRC_DIR)/philosophy/Index/%,$(filter $(T2_SRC_DIR)/philosophy/%,$(T2_DOCS_SRC))) $(filter $(T2_SRC_DIR)/prog-evolution/%,$(T2_DOCS_SRC))

$(T2_PHILOSOPHY_DOCS_SRC):: $(T2_SRC_DIR)/%.wml: $(PHILOSOPHY_DEPS)
	touch $@

T2_LECTURES_DOCS_SRC = $(filter $(T2_SRC_DIR)/lecture/%,$(T2_DOCS_SRC))

$(T2_LECTURES_DOCS_SRC):: $(T2_SRC_DIR)/lecture/%.wml: $(LECTURES_DEPS)
	touch $@

VIPE_LECTURES_DOCS_SRC = $(filter $(VIPE_SRC_DIR)/lecture/%,$(VIPE_DOCS_SRC))

$(VIPE_LECTURES_DOCS_SRC):: $(VIPE_SRC_DIR)/lecture/%.wml: $(LECTURES_DEPS)
	touch $@

COMMON_LECTURES_DOCS_SRC = $(patsubst %,common/%.wml,$(filter lecture/%,$(COMMON_DOCS)))

$(COMMON_LECTURES_DOCS_SRC):: common/lecture/%.wml: $(LECTURES_DEPS)
	touch $@

T2_SOFTWARE_DOCS_SRC = $(filter $(T2_SRC_DIR)/open-source/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/jmikmod/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/grad-fu/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/no-ie/%,$(T2_DOCS_SRC))

$(T2_SOFTWARE_DOCS_SRC):: $(T2_SRC_DIR)/%.wml: $(SOFTWARE_DEPS)
	touch $@

VIPE_SOFTWARE_DOCS_SRC = $(filter $(VIPE_SRC_DIR)/rwlock/%,$(VIPE_DOCS_SRC)) \
						 $(filter $(VIPE_SRC_DIR)/software-tools/%,$(VIPE_DOCS_SRC))

$(VIPE_SOFTWARE_DOCS_SRC):: $(VIPE_SRC_DIR)/%.wml: $(SOFTWARE_DEPS)
	touch $@


#### Humour thing

T2_HUMOUR_DOCS_SRC = $(filter $(T2_SRC_DIR)/humour/%,$(T2_DOCS_SRC)) \
					 $(filter $(T2_SRC_DIR)/humour.html.wml,$(T2_DOCS_SRC)) \
					 $(filter $(T2_SRC_DIR)/wysiwyt.html.wml,$(T2_DOCS_SRC)) \
					 $(filter $(T2_SRC_DIR)/wonderous.html.wml,$(T2_DOCS_SRC))

$(T2_HUMOUR_DOCS_SRC):: $(T2_SRC_DIR)/%.wml: $(HUMOUR_DEPS)
	touch $@

VIPE_HUMOUR_DOCS_SRC = $(filter $(VIPE_SRC_DIR)/humour/%,$(VIPE_DOCS_SRC))

$(VIPE_HUMOUR_DOCS_SRC):: $(VIPE_SRC_DIR)/%.wml: $(HUMOUR_DEPS)
	touch $@


T2_PUZZLES_DOCS_SRC = $(filter $(T2_SRC_DIR)/puzzles/%,$(T2_DOCS_SRC)) $(filter $(T2_SRC_DIR)/MathVentures/%,$(T2_DOCS_SRC))

$(T2_PUZZLES_DOCS_SRC):: $(T2_SRC_DIR)/%.wml: $(PUZZLES_DEPS)
	touch $@

rss:
	./bin/fetch-shlomif_hsite-feed.pl
	touch t2/index.html.wml
	touch t2/old-news.html.wml

T2_SITEMAP_FILE = $(T2_DEST)/sitemap.xml.gz

sitemap_targets: $(T2_SITEMAP_FILE)

$(T2_SITEMAP_FILE): bin/gen-google-site-map.pl
	$<

PROD_SYND_MUSIC_DIR = lib/prod-synd/music
PROD_SYND_MUSIC_INC = $(PROD_SYND_MUSIC_DIR)/include-me.html

$(T2_SRC_DIR)/art/recommendations/music/index.html.wml : $(PROD_SYND_MUSIC_INC)
	touch $@

$(PROD_SYND_MUSIC_INC) : $(PROD_SYND_MUSIC_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/art/recommendations/music/shlomi-fish-music-recommendations.xml
	perl $<
	./gen-helpers.pl
	svn add -q t2/art/recommendations/music/images/*.jpg
	$(MAKE)

%.show:
	@echo "$* = $($*)"

