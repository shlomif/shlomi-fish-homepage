POST_DEST := dest/post-incs/t2
LATEMP_ROOT_SOURCE_DIR := .
LATEMP_ABS_ROOT_SOURCE_DIR := $(realpath $(LATEMP_ROOT_SOURCE_DIR))

all: all_deps non_latemp_targets

all_deps: copy_fortunes docbook_targets fortunes-epub fortunes-target sects_cache

non_latemp_targets: art_slogans_targets copy_images_target css_targets generate_nav_data_as_json htaccesses_target hhgg_convert lc_pres_targets mathjax_dest minified_assets mod_files mojo_pres plaintext_scripts_with_offending_extensions printable_resumes__html presentations_targets site_source_install

include lib/make/shlomif_common.mak
include lib/make/tools.mak
include lib/make/include.mak

BK2HP_SVG_BASE := images/bk2hp-v2.svg
SRC_IMAGES += $(BK2HP_SVG_BASE)

include lib/make/rules.mak

PRE_DEST := $(SRC_DEST)
STRIP_src_dir_DEST := $(PERL) -lpe 's=\A(?:./)?$(PRE_DEST)/?=='

include lib/factoids/deps.mak
include lib/make/factoids.mak
include lib/make/docbook/sf-fictions-list.mak
include lib/make/long_stories.mak

BK2HP_SVG_SRC := $(SRC_SRC_DIR)/$(BK2HP_SVG_BASE)

POST_DEST_DIRS := $(addprefix $(POST_DEST)/,$(SRC_DIRS))

NAV_DATA_DEP := lib/MyNavData.pm

SCREENPLAY_COMMON_INC_DIR := $(LATEMP_ABS_ROOT_SOURCE_DIR)/lib/screenplay-xml/from-vcs/screenplays-common

DOCS_COMMON_DEPS := $(NAV_DATA_DEP)

FORTUNES_DIR := humour/fortunes
SRC_FORTUNES_DIR := $(SRC_SRC_DIR)/$(FORTUNES_DIR)

include $(SRC_FORTUNES_DIR)/fortunes-list.mak

MANIFEST_HTML := $(PRE_DEST)/MANIFEST.html
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

htacc = $(addsuffix /.htaccess,$(1))
SRC_FORTUNES_DIR_HTACCESS := $(call htacc,$(PRE_DEST_FORTUNES_DIR))

ALL_HTACCESSES := $(call htacc,$(PRE_DEST_FORTUNES_DIR) $(addprefix $(PRE_DEST)/,art lecture/PostgreSQL-Lecture philosophy/culture philosophy/culture/case-for-commercial-fan-fiction))

htaccesses_target: $(ALL_HTACCESSES)

$(SRC_FORTUNES_DIR)/my_htaccess.conf: $(SRC_FORTUNES_DIR)/gen-htaccess.pl
	(cd $(SRC_FORTUNES_DIR) && $(GNUMAKE))

$(PRE_DEST)/philosophy/Index/index.xhtml : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl

rss:
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/fetch-shlomif_hsite-feed.pl
	touch $(SRC_SRC_DIR)/index.xhtml.tt2 $(SRC_SRC_DIR)/old-news.html.tt2

include lib/make/prod-syndicate.mak
# Rebuild the pages containing the links to $(SRC_SRC_DIR)/humour/stories upon changing
# the lib/stories.

$(PRE_DEST_HUMOUR)/index.xhtml $(PRE_DEST_HUMOUR)/stories/index.xhtml $(PRE_DEST_HUMOUR)/stories/Star-Trek/index.xhtml $(PRE_DEST_HUMOUR)/stories/Star-Trek/We-the-Living-Dead/index.xhtml $(PRE_DEST_HUMOUR)/TheEnemy/index.xhtml: lib/stories/stories-list.tt2

$(PRE_DEST_HUMOUR)/humanity/index.xhtml $(PRE_DEST_HUMOUR)/humanity/ongoing-text.html $(PRE_DEST_HUMOUR)/humanity/buy-the-fish-in-hebrew.html $(PRE_DEST_HUMOUR)/humanity/ongoing-text-hebrew.html : lib/stories/blurbs.tt2

include lib/make/fortunes-targets.mak
include lib/make/stories-wrapper.mak
include lib/make/docbook/sf-docbook-common.mak
include lib/make/docbook/sf-fictions.mak
include lib/make/sf-essays.mak
include lib/make/sf-mkdirs.mak

# Avoid docmake's --verbose flag; an optimization
DOCMAKE_WITH_PARAMS := $(DOCMAKE)

C_BAD_ELEMS_SRC := lib/c-begin/C-and-CPP-elements-to-avoid/c-and-cpp-elements-to-avoid.xml-grammar-vered.xml
POST_DEST__C_BAD_ELEMS := $(POST_DEST)/lecture/C-and-CPP/bad-elements/c-and-cpp-elements-to-avoid.xml-grammar-vered.xml

$(DOCBOOK5_SOURCES_DIR)/c-and-cpp-elements-to-avoid.xml: $(C_BAD_ELEMS_SRC)
	$(VERED) --output "$@" "$<"

all: $(POST_DEST__C_BAD_ELEMS)

ART_SLOGANS_DOCS := \
	chromaticd/kiss-me-my-blog-post-got-chormaticd \
	CPP-supports-OOP/CPP-supports-OOP-as-much-as \
	dont-believe-in-fairies/dont-believe-in-fairies  \
	give-me-ascii/give-me-ASCII-or-give-me-death \
	lottery-all-you-need-is-a-dollar/lottery-all-you-need-is-a-dollar \
	what-do-you-mean-by-wdym/what-do-you-mean-by-wdym \

ART_SLOGANS_PATHS := $(addprefix $(POST_DEST)/art/slogans/,$(ART_SLOGANS_DOCS))
ART_SLOGANS_PNGS := $(addsuffix .png,$(ART_SLOGANS_PATHS))
ART_SLOGANS_THUMBS := $(addsuffix .thumb.png,$(ART_SLOGANS_PATHS))

BK2HP_NEW_PNG := $(POST_DEST)/images/bk2hp.png

include lib/make/presentations-targets.mak
include lib/make/sf-css.mak
include lib/make/stories-targets.mak
include lib/make/deps.mak
include lib/make/sf-javascripts.mak
include lib/make/sf-printables.mak

all: $(MANIFEST_HTML)

tags:
	ctags -R --exclude='.git/**' --exclude='*~' .

SRC_CACHE_PREFIX := lib/cache/combined/t2

$(SRC_DOCS_DEST): $(PRE_DEST)/%: \
	$(SRC_CACHE_PREFIX)/%/breadcrumbs-trail \
	$(SRC_CACHE_PREFIX)/%/html_head_nav_links \
	$(SRC_CACHE_PREFIX)/%/main_nav_menu_html \
	$(SRC_CACHE_PREFIX)/%/sect-navmenu \
	$(SRC_CACHE_PREFIX)/%/shlomif_nav_links_renderer-with_accesskey= \
	$(SRC_CACHE_PREFIX)/%/shlomif_nav_links_renderer-with_accesskey=1 \

all: $(SRC_CLEAN_STAMP)

PROC_INCLUDES_COMMON2 = APPLY_TEXTS=1 xargs $(PROCESS_ALL_INCLUDES__NON_INPLACE) --mode=minify --minifier-conf=bin/html-min-cli-config-file.conf --texts-dir=lib/ads --source-dir=$(1) --dest-dir=$(2) --
PROC_INCLUDES_COMMON := $(call PROC_INCLUDES_COMMON2,$(PRE_DEST),$(POST_DEST))

SKIP_EPUBS_NORMALIZE_DUE_TO_INVALID_EPUBS = 0

$(SRC_CLEAN_STAMP): $(BK2HP_NEW_PNG) $(DOCBOOK5_INSTALLED_EPUBS) $(FORTS_EPUB_DEST) $(FORTUNES_BUILT_TARGETS) $(MANIFEST_HTML) $(MATHJAX_DEST_README) $(POST_DEST_XZ_MODS) $(POST_DEST_ZIP_MODS) $(PRES_TARGETS_ALL_FILES) $(SCREENPLAY_XML__EPUBS_DESTS) $(SCREENPLAY_XML__RAW_HTMLS__DESTS) $(SPORK_LECTURES_DEST_STARTS) $(SRC_DOCS_DEST)
	$(call find_htmls,$(PRE_DEST)) | grep -vF -e philosophy/by-others/sscce -e WebMetaLecture/slides/examples -e homesteading/catb-heb | $(STRIP_src_dir_DEST) | $(PROC_INCLUDES_COMMON)
	rsync --exclude '*.html' --exclude '*.xhtml' -a $(PRE_DEST)/ $(POST_DEST)/
	if test "$(SKIP_EPUBS_NORMALIZE_DUE_TO_INVALID_EPUBS)" != "1" ; then find $(POST_DEST) -name '*.epub' -o -name '*.zip' | xargs -n 3 -P 8 $(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/normalize-zips.pl ; fi
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/gen-index-xhtmls-redirects.pl
	WMLect_PATH="lecture/WebMetaLecture/slides/examples" ; rsync -a $(PRE_DEST)/$$WMLect_PATH/ $(POST_DEST)/$$WMLect_PATH
	touch $@

docbook_extended: screenplays_pdfs

FASTRENDER_DEPS := $(patsubst $(PRE_DEST)/%,$(SRC_SRC_DIR)/%.tt2,$(SRC_DOCS_DEST)) all_deps

include lib/make/pages-sects.mak

fastrender: fastrender-tt2 $(SRC_FORTUNES_ALL__HTML)

fastrender-tt2: $(FASTRENDER_DEPS)
	@echo $(MAKE) fastrender-tt2
	perl bin/tt-render.pl

copy_images_target: $(SRC_IMAGES_DEST) $(SRC_COMMON_IMAGES_DEST)

TEST_TARGETS := Tests/*.{py,t}

POST_DEST_FIERY_Q_PNG := $(POST_DEST_HUMOUR)/Star-Trek/We-the-Living-Dead/images/fiery-Q.png
CATB_HEB_BN := catb-heb.xhtml
CATB_COPY := $(PRE_DEST)/$(CATB_HEB_BN)
CATB_COPY_POST := $(POST_DEST)/$(CATB_HEB_BN)

include lib/make/image-files.mak
include lib/make/copies-generated-include.mak
include lib/make/docbook/screenplays-copy-operations.mak

minified_assets: $(BK2HP_SVG_SRC) $(EXPANDER_JS_DEST) $(EXPANDER_MIN_JS_DEST) $(MAIN_TOTAL_MIN_JS_DEST) $(SRC_SVGS__MIN) $(SRC_SVGS__svgz) $(SRC_jpgs__webps) $(SRC_pngs__webps) $(SRC_rjpgs__webps) $(TREE_JS_DEST)
screenplay_targets: $(SCREENPLAY_SOURCES_ON_POST_DEST__EXTRA_TARGETS)

non_latemp_targets: $(SRC_SRC_FORTUNE_SHOW_PY)

$(MANIFEST_HTML): $(LATEMP_ROOT_SOURCE_DIR)/bin/gen-manifest.pl $(ALL_HTACCESSES) $(SPORK_LECTURES_DEST_STARTS)
	$(PERL) $<

all: $(CATB_COPY_POST)

include lib/make/asciidocs2db5-generated-include.mak
include lib/make/json_resume.mak
include lib/make/jquery-ui-webpack.mak
include lib/make/mod_files.mak
include lib/make/summer_glau_letter.mak
include lib/make/upload.mak
include lib/make/factoids-deps.mak
include lib/make/sf-mail-lists.mak

all_deps: $(JQUERYUI_JS_DESTS)
all_deps: $(JQUI_webpack_dest)
all_deps: $(SRC_IMAGES_DEST)

TEST_ENV = PYTHONPATH="$${PYTHONPATH}:$(LATEMP_ABS_ROOT_SOURCE_DIR)/Tests/lib"

.PHONY: bulk-make-dirs fortunes-compile-xmls install_docbook_css_dirs install_docbook_individual_xhtmls install_docbook_xmls make-dirs mod_files presentations_targets
