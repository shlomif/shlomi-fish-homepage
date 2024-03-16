POST_DEST := dest/post-incs/t2
LATEMP_ROOT_SOURCE_DIR := .
LATEMP_ABS_ROOT_SOURCE_DIR := $(realpath $(LATEMP_ROOT_SOURCE_DIR))

all: all_deps non_latemp_targets post_latemp_deps

all_deps: copy_fortunes docbook_targets fortunes-epub fortunes-target sects_cache

non_latemp_targets: art_slogans_targets copy_images_target css_targets generate_nav_data_as_json htaccesses_target hhgg_convert lc_pres_targets mathjax_dest minified_assets mod_files mojo_pres plaintext_scripts_with_offending_extensions printable_resumes__html presentations_targets site_source_install

include lib/make/shlomif_common.mak
include lib/make/tools.mak
include lib/make/generated/include.mak

BK2HP_SVG_BASE := images/bk2hp-v2.svg
SRC_IMAGES += $(BK2HP_SVG_BASE)

include lib/make/sf-filefind-rules.mak

PRE_DEST := $(SRC_DEST)

include lib/make/factoids.mak
include lib/make/generated/sf-fictions-list.mak
include lib/make/generated/long_stories.mak

BK2HP_SVG_SRC := $(SRC_SRC_DIR)/$(BK2HP_SVG_BASE)

POST_DEST_DIRS := $(addprefix $(POST_DEST)/,$(SRC_DIRS))

NAV_DATA_DEP := lib/MyNavData.pm

SCREENPLAY_COMMON_INC_DIR := $(LATEMP_ABS_ROOT_SOURCE_DIR)/lib/screenplay-xml/from-vcs/screenplays-common

DOCS_COMMON_DEPS := $(NAV_DATA_DEP)

FORTUNES_DIR := humour/fortunes
SRC_FORTUNES_DIR := $(SRC_SRC_DIR)/$(FORTUNES_DIR)

$(BK2HP_SVG_SRC): lib/repos/Shlomi-Fish-Back-to-my-Homepage-Logo/back-to-my-homepage-logo/back-to-my-homepage--scripted-final--with-gradient-applied--cropped.svg
	python3 bin/process-bk2hp.py --output $@ --input $<

include $(SRC_FORTUNES_DIR)/fortunes-list.mak

MANIFEST_HTML := $(POST_DEST)/MANIFEST.html
SITE_SOURCE_INSTALL_TARGET := $(POST_DEST)/meta/site-source/INSTALL
PRE_DEST_FORTUNES_DIR := $(PRE_DEST)/$(FORTUNES_DIR)
POST_DEST_FORTUNES_DIR := $(POST_DEST)/$(FORTUNES_DIR)

include lib/make/sects_dependencies.mak

SRC_CACHE_ALL_STAMP := lib/cache/STAMP.sects-includes
SRC_CLEAN_STAMP := lib/cache/STAMP.post-dest

GEN_CACHE_CMD := $(PERL) $(GEN_SECT_NAV_MENUS)

$(SRC_CACHE_ALL_STAMP): $(GEN_SECT_NAV_MENUS) $(ALL_SUBSECTS_DEPS)
	@echo "Generating sects_cache"
	$(GEN_CACHE_CMD)
	touch $@

sects_cache: make-dirs $(SRC_CACHE_ALL_STAMP)

site_source_install: $(SITE_SOURCE_INSTALL_TARGET)

PRE_DEST_HUMOUR := $(PRE_DEST)/humour
POST_DEST_HUMOUR := $(POST_DEST)/humour
POST_DEST_POPE := $(POST_DEST_HUMOUR)/Pope

all_deps: $(POST_DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.xml
all_deps: $(POST_DEST_POPE)/The-Pope-Died-on-Sunday-english.xml

$(PRE_DEST)/philosophy/Index/index.xhtml : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl

rss:
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/fetch-shlomif_hsite-feed.pl
	touch $(SRC_SRC_DIR)/index.xhtml.tt2 $(SRC_SRC_DIR)/old-news.html.tt2

include lib/make/htaccesses.mak
include lib/make/prod-syndicate.mak
# Rebuild the pages containing the links to $(SRC_SRC_DIR)/humour/stories upon changing
# the lib/stories.

$(PRE_DEST_HUMOUR)/index.xhtml $(PRE_DEST_HUMOUR)/stories/index.xhtml $(PRE_DEST_HUMOUR)/stories/Star-Trek/index.xhtml $(PRE_DEST_HUMOUR)/stories/Star-Trek/We-the-Living-Dead/index.xhtml $(PRE_DEST_HUMOUR)/TheEnemy/index.xhtml: lib/stories/stories-list.tt2

$(PRE_DEST_HUMOUR)/humanity/index.xhtml $(PRE_DEST_HUMOUR)/humanity/ongoing-text.html $(PRE_DEST_HUMOUR)/humanity/buy-the-fish-in-hebrew.html $(PRE_DEST_HUMOUR)/humanity/ongoing-text-hebrew.html : lib/stories/blurbs.tt2

include lib/make/fortunes-targets.mak
include lib/make/stories-wrapper.mak
include lib/make/docbook/sf-docbook-common.mak
include lib/make/generated/sf-fictions.mak
include lib/make/sf-essays.mak
include lib/make/sf-mkdirs.mak

# Avoid docmake's --verbose flag; an optimization
DOCMAKE_WITH_PARAMS := $(DOCMAKE)

C_BAD_ELEMS_SRC := lib/c-begin/C-and-CPP-elements-to-avoid/c-and-cpp-elements-to-avoid.xml-grammar-vered.xml
POST_DEST__C_BAD_ELEMS := $(POST_DEST)/lecture/C-and-CPP/bad-elements/c-and-cpp-elements-to-avoid.xml-grammar-vered.xml

$(DOCBOOK5_SOURCES_DIR)/c-and-cpp-elements-to-avoid.xml: $(C_BAD_ELEMS_SRC)
	$(VERED) --output "$@" "$<"

non_latemp_targets: $(POST_DEST__C_BAD_ELEMS)

BK2HP_NEW_PNG := $(POST_DEST)/images/bk2hp.png

include lib/make/presentations-targets.mak
include lib/make/sf-css.mak
include lib/make/stories-targets.mak
include lib/make/generated/deps.mak
include lib/make/sf-javascripts.mak
include lib/make/sf-printables.mak

post_latemp_deps: $(MANIFEST_HTML)

tags:
	ctags -R --exclude='.git/**' --exclude='*~' .

include lib/make/sf-post-dest.mak
include lib/make/pages-sects.mak

TEST_TARGETS := Tests/*.{py,t}

POST_DEST_FIERY_Q_PNG := $(POST_DEST_HUMOUR)/Star-Trek/We-the-Living-Dead/images/fiery-Q.png
CATB_HEB_BN := catb-heb.xhtml
CATB_COPY := $(PRE_DEST)/$(CATB_HEB_BN)
CATB_COPY_POST := $(POST_DEST)/$(CATB_HEB_BN)

include lib/make/image-files.mak
include lib/make/generated/copies-generated-include.mak
include lib/make/generated/screenplays-copy-operations.mak

minified_assets: $(BK2HP_SVG_SRC) $(EXPANDER_JS_DEST) $(EXPANDER_MIN_JS_DEST) $(MAIN_TOTAL_MIN_JS_DEST) $(SRC_SVGS__MIN) $(SRC_SVGS__svgz) $(SRC_jpgs__webps) $(SRC_pngs__webps) $(SRC_rjpgs__webps) $(TREE_JS_DEST)
screenplay_targets: $(SCREENPLAY_SOURCES_ON_POST_DEST__EXTRA_TARGETS)

$(MANIFEST_HTML): $(LATEMP_ROOT_SOURCE_DIR)/bin/gen-manifest.pl $(ALL_HTACCESSES) $(SPORK_LECTURES_DEST_STARTS) $(FORTS_EPUB_DEST) $(SRC_CLEAN_STAMP)
	$(PERL) $<

non_latemp_targets: $(CATB_COPY_POST)

include lib/make/generated/asciidocs2db5-include.mak
include lib/make/json_resume.mak
include lib/make/jquery-ui-webpack.mak
include lib/make/mod_files.mak
include lib/make/summer_glau_letter.mak
include lib/make/upload.mak
include lib/make/generated/factoids-deps.mak

all_deps: $(JQUERYUI_JS_DESTS)
all_deps: $(JQUI_webpack_dest)
all_deps: $(SRC_IMAGES_DEST)

TEST_ENV = PYTHONPATH="$${PYTHONPATH}:$(LATEMP_ABS_ROOT_SOURCE_DIR)/Tests/lib"

.PHONY: bulk-make-dirs fortunes-compile-xmls install_docbook_css_dirs install_docbook_individual_xhtmls install_docbook_xmls make-dirs mod_files presentations_targets
