POST_DEST := dest/post-incs/t2
LATEMP_ROOT_SOURCE_DIR := .
LATEMP_ABS_ROOT_SOURCE_DIR := $(realpath $(LATEMP_ROOT_SOURCE_DIR))
SASS_DEBUG_FLAGS :=

MATHJAX_SOURCE_README := lib/js/MathJax/README.md

all: all_deps non_latemp_targets

all_deps: sects_cache docbook_targets fortunes-epub fortunes-target copy_fortunes

non_latemp_targets: art_slogans_targets copy_images_target css_targets generate_nav_data_as_json htaccesses_target hhgg_convert lc_pres_targets mathjax_dest minified_assets mod_files mojo_pres plaintext_scripts_with_offending_extensions printable_resumes__html presentations_targets site_source_install svg_nav_images

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

COMMON_POST_DEST_DIRS := $(addprefix $(POST_DEST)/,$(COMMON_DIRS))

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
FORTUNES_TARGET :=  $(PRE_DEST_FORTUNES_DIR)/index.xhtml

FORTUNES_ALL_IN_ONE__BASE := all-in-one.html
FORTUNES_ALL_IN_ONE__TEMP__BASE := all-in-one.uncompressed.html
SRC_FORTUNES_ALL__HTML := $(PRE_DEST_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__BASE)
SRC_FORTUNES_ALL__HTML__POST := $(POST_DEST_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__TEMP__BASE)
SRC_FORTUNES_ALL_TT2 := $(SRC_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__TEMP__BASE).tt2

SECTS_DEPS__DIR := lib/Shlomif/Homepage/SectionMenu/Sects
SECTION_MENU_DEPS := lib/Shlomif/Homepage/SectionMenu.pm

ART_DEPS := $(SECTS_DEPS__DIR)/Art.pm
HUMOUR_DEPS := $(SECTS_DEPS__DIR)/Humour.pm
LECTURES_DEPS := $(SECTS_DEPS__DIR)/Lectures.pm
META_SUBSECT_DEPS := $(SECTS_DEPS__DIR)/Meta.pm
PHILOSOPHY_DEPS := $(SECTS_DEPS__DIR)/Essays.pm
PUZZLES_DEPS := $(SECTS_DEPS__DIR)/Puzzles.pm
SOFTWARE_DEPS := $(SECTS_DEPS__DIR)/Software.pm

ALL_SUBSECTS_DEPS := $(ART_DEPS) $(HUMOUR_DEPS) $(LECTURES_DEPS) $(META_SUBSECT_DEPS) $(PHILOSOPHY_DEPS) $(PUZZLES_DEPS) $(SECTION_MENU_DEPS) $(SOFTWARE_DEPS)

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

SRC_SRC_FORTUNE_SHOW_SCRIPT := $(SRC_SRC_DIR)/$(FORTUNES_DIR)/show.cgi
FORTUNE_SHOW_PY__BN := fortunes_show.py
SRC_SRC_FORTUNE_SHOW_PY := $(SRC_SRC_DIR)/$(FORTUNES_DIR)/$(FORTUNE_SHOW_PY__BN)
SRC_SRC_BOTTLE := $(SRC_SRC_DIR)/$(FORTUNES_DIR)/bottle.py
POST_DEST_FORTUNE_SHOW_SCRIPT_TXT := $(POST_DEST_FORTUNES_DIR)/show-cgi.txt

htacc = $(addsuffix /.htaccess,$(1))
SRC_FORTUNES_DIR_HTACCESS := $(call htacc,$(PRE_DEST_FORTUNES_DIR))

ALL_HTACCESSES := $(call htacc,$(PRE_DEST_FORTUNES_DIR) $(addprefix $(PRE_DEST)/,art lecture/PostgreSQL-Lecture philosophy/culture philosophy/culture/case-for-commercial-fan-fiction))

htaccesses_target: $(ALL_HTACCESSES)

$(SRC_FORTUNES_DIR)/my_htaccess.conf: $(SRC_FORTUNES_DIR)/gen-htaccess.pl
	(cd $(SRC_FORTUNES_DIR) && $(GNUMAKE))

$(SRC_FORTUNES_ALL_TT2): $(LATEMP_ROOT_SOURCE_DIR)/bin/gen-forts-all-in-one-page.pl $(FORTUNES_LIST_PM)
	$(PERL) -I $(LATEMP_ROOT_SOURCE_DIR)/lib $< $@

PRE_DEST_FORTUNES := $(patsubst $(SRC_FORTUNES_DIR)/%,$(PRE_DEST_FORTUNES_DIR)/%,$(wildcard $(SRC_FORTUNES_DIR)/fortunes-shlomif-*.tar.gz))

chmod_copy = $(call COPY) ; chmod +x $@

$(SRC_SRC_FORTUNE_SHOW_PY): $(SRC_SRC_FORTUNE_SHOW_SCRIPT)
	$(call chmod_copy)

$(PRE_DEST)/philosophy/Index/index.xhtml : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl

rss:
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/fetch-shlomif_hsite-feed.pl
	touch $(SRC_SRC_DIR)/index.xhtml.tt2 $(SRC_SRC_DIR)/old-news.html.tt2

include lib/make/prod-syndicate.mak

PUT_CARDS_2013_XHTML := lib/pages/t2/philosophy/putting-all-cards-on-the-table.xhtml
PUT_CARDS_2013_DEST := $(PRE_DEST)/philosophy/philosophy/put-cards-2013.xhtml

PUT_CARDS_2013_XHTML_STRIPPED := $(PUT_CARDS_2013_XHTML).processed-stripped

STRIP_HTML_BIN := $(LATEMP_ROOT_SOURCE_DIR)/bin/processors/strip-html-overhead.pl
strip_html = $(PERL) $(STRIP_HTML_BIN) < $< > $@

$(PUT_CARDS_2013_XHTML_STRIPPED): $(PUT_CARDS_2013_XHTML) $(STRIP_HTML_BIN)
	$(call strip_html)

HOW_TO_GET_HELP_2013_XHTML := lib/pages/t2/philosophy/how-to-get-help-online.xhtml
HOW_TO_GET_HELP_2013_XHTML_STRIPPED := $(HOW_TO_GET_HELP_2013_XHTML).processed-stripped

$(HOW_TO_GET_HELP_2013_XHTML_STRIPPED): $(HOW_TO_GET_HELP_2013_XHTML) $(STRIP_HTML_BIN)
	$(call strip_html)

$(PRE_DEST)/philosophy/computers/how-to-get-help-online/2013.html: $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)

all_deps: $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)

all: $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)

# Rebuild the pages containing the links to $(SRC_SRC_DIR)/humour/stories upon changing
# the lib/stories.

$(PRE_DEST_HUMOUR)/index.xhtml $(PRE_DEST_HUMOUR)/stories/index.xhtml $(PRE_DEST_HUMOUR)/stories/Star-Trek/index.xhtml $(PRE_DEST_HUMOUR)/stories/Star-Trek/We-the-Living-Dead/index.xhtml $(PRE_DEST_HUMOUR)/TheEnemy/index.xhtml: lib/stories/stories-list.tt2

$(PRE_DEST_HUMOUR)/humanity/index.xhtml $(PRE_DEST_HUMOUR)/humanity/ongoing-text.html $(PRE_DEST_HUMOUR)/humanity/buy-the-fish-in-hebrew.html $(PRE_DEST_HUMOUR)/humanity/ongoing-text-hebrew.html : lib/stories/blurbs.tt2

include lib/make/fortunes-targets.mak

MOJOLICIOUS_LECTURE_SLIDE1 := $(PRE_DEST)/lecture/Perl/Lightning/Mojolicious/mojolicious-slides.html

HACKING_DOC := $(PRE_DEST)/open-source/resources/how-to-contribute-to-my-projects/HACKING.html

mojo_pres: $(MOJOLICIOUS_LECTURE_SLIDE1) $(HACKING_DOC)

christina_grimmie_letter_source = lib/asciidocs/letter-to-christina-grimmie.asciidoc
christina_grimmie_letter_html = lib/asciidocs/letter-to-christina-grimmie.asciidoc.xhtml

$(christina_grimmie_letter_html): $(christina_grimmie_letter_source)
	$(call ASCIIDOCTOR_TO_RAW_XHTML5)

$(MOJOLICIOUS_LECTURE_SLIDE1): $(SRC_SRC_DIR)/lecture/Perl/Lightning/Mojolicious/mojolicious.asciidoc.txt
	$(call ASCIIDOCTOR_TO_XHTML5)

$(HACKING_DOC): $(SRC_SRC_DIR)/open-source/resources/how-to-contribute-to-my-projects/HACKING.txt
	$(call ASCIIDOCTOR_TO_XHTML5)

include lib/make/stories-wrapper.mak
include lib/make/docbook/sf-docbook-common.mak
include lib/make/docbook/sf-fictions.mak

# Avoid docmake's --verbose flag; an optimization
DOCMAKE_WITH_PARAMS := $(DOCMAKE)

ALL_DIRS__TO_make_dirs := $(COMMON_POST_DEST_DIRS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS__DIRS) $(DOCBOOK5_INDIVIDUAL_XHTML__POST_DEST__DIRS) $(HHFG_V2_IMAGES_DEST_DIR) $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS) $(HHFG_V2_IMAGES_POST_DEST_DIR) $(POST_DEST_DIRS)

ALL_DIRS := $(ALL_DIRS__TO_make_dirs) $(HHFG_V2_IMAGES_POST_DEST_DIR_FROM_VCS) $(SRC_COMMON_DIRS_DEST) $(SRC_DIRS_DEST)

bulk-make-dirs:
	@mkdir -p $(ALL_DIRS)

make-dirs: $(ALL_DIRS)

$(ALL_DIRS__TO_make_dirs): %:
	mkdir -p $@
	touch $@

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

MATHJAX_DEST_DIR := $(POST_DEST)/js/MathJax
MATHJAX_DEST_README := $(MATHJAX_DEST_DIR)/README.md

mathjax_dest: make-dirs $(MATHJAX_DEST_README)

$(MATHJAX_DEST_README): $(MATHJAX_SOURCE_README)
	@mkdir -p $(MATHJAX_DEST_DIR)/
	cp -PR lib/js/MathJax/{LICENSE,README.md,es5/} $(MATHJAX_DEST_DIR)/

SCRIPTS_WITH_OFFENDING_EXTENSIONS := MathVentures/gen-bugs-in-square-svg.pl open-source/bits-and-bobs/nowplay-xchat.pl open-source/bits-and-bobs/pmwiki-revert.pl open-source/bits-and-bobs/convert-kabc-dist-lists.pl

SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS := $(patsubst %.pl,$(POST_DEST)/%-pl.txt,$(SCRIPTS_WITH_OFFENDING_EXTENSIONS))

plaintext_scripts_with_offending_extensions: $(SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS)

svg_nav_images:

NAV_DATA_AS_JSON := $(POST_DEST)/_data/nav.json

generate_nav_data_as_json: $(NAV_DATA_AS_JSON)

$(NAV_DATA_AS_JSON): $(NAV_DATA_DEP) $(NAV_DATA_AS_JSON_BIN) lib/Shlomif/Homepage/NavData/JSON.pm $(ALL_SUBSECTS_DEPS)
	./$(NAV_DATA_AS_JSON_BIN) -o $@

OUT_PREF = lib/out-babel/js
TYPESCRIPT_basenames = decss_for_typescript.js resize-iframe.js selfl.js sub_menu.js to-jqtree-2.js to-jqtree.js toggle_sect.js toggler.js
DEST_JS_DIR = $(POST_DEST)/js
dest_jsify = $(addprefix $(DEST_JS_DIR)/,$(1))

TYPESCRIPT_DEST_FILES = $(patsubst %.js,$(OUT_PREF)/%.js,$(TYPESCRIPT_basenames))
TYPESCRIPT_DEST_FILES__NODE = $(patsubst %.js,lib/for-node/js/%.js,$(TYPESCRIPT_basenames))
TYPESCRIPT_COMMON_DEFS_FILES = src/ts/jq_qs.d.ts
TYPESCRIPT_COMMON_DEPS =

DEST_BABEL_JSES = $(call dest_jsify,$(JSES_js_basenames) $(TYPESCRIPT_basenames))
OUT_BABEL_JSES = $(patsubst $(DEST_JS_DIR)/%,$(OUT_PREF)/%,$(DEST_BABEL_JSES))

$(DEST_BABEL_JSES): $(DEST_JS_DIR)/%.js: $(OUT_PREF)/%.js
	$(MULTI_YUI) -o $@ $<

all: $(call dest_jsify, resize-iframe.js)

# run_tsc = tsc --target es6 --moduleResolution node --module $1 --outDir $$(dirname $@) $<
run_tsc = tsc --project lib/typescript/$1/tsconfig.json

$(TYPESCRIPT_DEST_FILES): $(OUT_PREF)/%.js: src/ts/%.ts $(TYPESCRIPT_COMMON_DEPS)
	$(call run_tsc,www)

$(TYPESCRIPT_DEST_FILES__NODE): lib/for-node/js/%.js: src/ts/%.ts $(TYPESCRIPT_COMMON_DEPS)
	$(call run_tsc,cmdline)

tsc_www:
	$(call run_tsc,www)

tsc_cmdline:
	$(call run_tsc,cmdline)

serial_run: tsc_www tsc_cmdline

$(PRE_DEST)/site-map/index.xhtml: $(ALL_SUBSECTS_DEPS)

MAIN_TOTAL_MIN_JS_DEST := $(POST_DEST)/js/main_all.js
TREE_JS_DEST := $(POST_DEST)/js/tree.jquery.js
EXPANDER_MIN_JS_DEST := $(POST_DEST)/js/jquery.expander.min.js
EXPANDER_JS_DEST := $(POST_DEST)/js/jquery.expander.js
EXPANDER_JS_SRC := lib/js/jquery-expander/jquery.expander.js
MULTI_YUI := $(LATEMP_ROOT_SOURCE_DIR)/bin/Run-YUI-Compressor

$(EXPANDER_MIN_JS_DEST): $(EXPANDER_JS_SRC)
	$(MULTI_YUI) -o $@ $<

# Must not be sorted!
MAIN_TOTAL_MIN_JS__SOURCES := \
	bower_components/jquery/dist/jquery.min.js \
	$(DEST_JS_DIR)/toggler.js \
	$(DEST_JS_DIR)/toggle_sect.js \
	bower_components/jqTree/tree.jquery.js \
	$(DEST_JS_DIR)/to-jqtree.js \
	$(DEST_JS_DIR)/to-jqtree-2.js \
	$(DEST_JS_DIR)/selfl.js \
	$(DEST_JS_DIR)/sub_menu.js \

$(MAIN_TOTAL_MIN_JS_DEST): $(MULTI_YUI) $(MAIN_TOTAL_MIN_JS__SOURCES)
	$(MULTI_YUI) -o $@ $(MAIN_TOTAL_MIN_JS__SOURCES)

$(TREE_JS_DEST): bower_components/jqTree/tree.jquery.js
	$(call COPY)

PRINTABLE_DEST_DIR := dest/printable
PRINTABLE_RESUMES__HTML__PIVOT := $(PRINTABLE_DEST_DIR)/Shlomi-Fish-English-Resume-Detailed.html
PRINTABLE_RESUMES__HTML := $(PRINTABLE_RESUMES__HTML__PIVOT) $(addprefix $(PRINTABLE_DEST_DIR)/,Shlomi-Fish-English-Resume.html Shlomi-Fish-Heb-Resume.html Shlomi-Fish-Resume-as-Software-Dev.html)

printable_resumes__html : $(PRINTABLE_RESUMES__HTML__PIVOT)

PRINTABLE_RESUMES__DOCX := $(patsubst %.html,%.docx,$(PRINTABLE_RESUMES__HTML))

$(PRINTABLE_RESUMES__DOCX): %.docx: %.html
	libreoffice --writer --headless --convert-to docx --outdir $(PRINTABLE_DEST_DIR) $<

$(PRINTABLE_RESUMES__HTML__PIVOT): $(PRE_DEST)/SFresume.html $(PRE_DEST)/SFresume_detailed.html $(PRE_DEST)/me/resumes/Shlomi-Fish-Heb-Resume.html $(PRE_DEST)/me/resumes/Shlomi-Fish-Resume-as-Software-Dev.html
	bash bin/gen-printable-CVs.sh
	cp -f $(PRINTABLE_DEST_DIR)/SFresume.html $(PRINTABLE_DEST_DIR)/Shlomi-Fish-English-Resume.html
	cp -f $(PRINTABLE_DEST_DIR)/SFresume_detailed.html $(PRINTABLE_DEST_DIR)/Shlomi-Fish-English-Resume-Detailed.html

resumes: $(PRINTABLE_RESUMES__DOCX)

PUT_CARDS_2013_DEST_INDIV := $(PRE_DEST)/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/tie_your_camel.xhtml
PUT_CARDS_2013_INDIV_SCRIPT := $(LATEMP_ROOT_SOURCE_DIR)/bin/split-put-cards-into-divs.pl

all: $(PUT_CARDS_2013_DEST_INDIV)

$(PUT_CARDS_2013_DEST_INDIV): $(PUT_CARDS_2013_XHTML) $(PUT_CARDS_2013_INDIV_SCRIPT)
	$(PERL) $(PUT_CARDS_2013_INDIV_SCRIPT)

all: manifest_html

manifest_html: $(MANIFEST_HTML)

LC_LECTURE_ARC_BASE := Lambda-Calculus.tar.gz
LC_LECTURE_ARC_DIR := $(PRE_DEST)/lecture
LC_LECTURE_ARC := $(LC_LECTURE_ARC_DIR)/$(LC_LECTURE_ARC_BASE)

all: $(LC_LECTURE_ARC)

$(LC_LECTURE_ARC): $(LC_PRES_DEST_HTMLS__PIVOT)
	(filelist() { find Lambda-Calculus/slides -type f -print | (LC_ALL=C sort) ; } ; cd $(LC_LECTURE_ARC_DIR) && touch -d 2021-01-29T08:53:00Z $$(filelist) && tar $(QUADPRES__TAR_OPTIONS) "--mode=go=rX,u+rw,a-s" -caf $(LC_LECTURE_ARC_BASE) $$(filelist))

RINDOLF_IMAGES_POST_DEST := $(POST_DEST)/me/rindolf/images
GRIMMIE_IMAGES_POST_DEST := $(POST_DEST)/art/recommendations/music/online-artists/fan-pages/chris-grimmie/images

RPG_DICE_SET_SRC := $(RINDOLF_IMAGES_POST_DEST)/rpg-dice-set--on-nuc.webp
RPG_DICE_SET_DEST := $(RINDOLF_IMAGES_POST_DEST)/rpg-dice-set--on-nuc--thumb.webp

GRIMMIE_IMG_SRC := $(GRIMMIE_IMAGES_POST_DEST)/christina-grimmie--529031666.jpg
GRIMMIE_IMG_DEST := $(GRIMMIE_IMAGES_POST_DEST)/christina-grimmie--529031666-r.webp
MY_NAME_IS_RINDOLF_SRC := $(RINDOLF_IMAGES_POST_DEST)/my-name-is-rindolf.jpg
MY_NAME_IS_RINDOLF_DEST := $(RINDOLF_IMAGES_POST_DEST)/my-name-is-rindolf-200w.jpg

Shlomif_cutethulhu_SRC := common/images/shlomif-cutethulhu.webp
Shlomif_cutethulhu_DEST := $(POST_DEST)/images/shlomif-cutethulhu-small.webp
Evilphish_flipped_src := $(POST_DEST)/images/evilphish.png

DnD_lances_cartoon_DEST := $(POST_DEST)/art/d-and-d-cartoon--comparing-lances/d-and-d-cartoon-exported.webp

POST_DEST__HUMOUR_IMAGES := $(POST_DEST_HUMOUR)/images

MY_RPF_DEST_DIR := $(POST_DEST)/philosophy/culture/my-real-person-fan-fiction
MY_RPF_DEST_PIVOT := $(MY_RPF_DEST_DIR)/euler.webp

OPENLY_BIPOLAR_DEST_DIR := $(POST_DEST)/philosophy/psychology/why-openly-bipolar-people-should-not-be-medicated/
OPENLY_BIPOLAR_DEST_PIVOT := $(OPENLY_BIPOLAR_DEST_DIR)/alan_turing.webp

all: $(MY_RPF_DEST_PIVOT) $(OPENLY_BIPOLAR_DEST_PIVOT)
all: $(MY_NAME_IS_RINDOLF_DEST)

SUB_REPOS_BASE_DIR := $(LATEMP_ROOT_SOURCE_DIR)/lib/repos

MY_RPF_SRC_DIR := $(SUB_REPOS_BASE_DIR)/my-real-person-fan-fiction

$(MY_RPF_DEST_PIVOT): $(MY_RPF_SRC_DIR)/euler.webp
	cp -f $(MY_RPF_SRC_DIR)/*.webp $(MY_RPF_DEST_DIR)/

OPENLY_BIPOLAR_SRC_DIR := $(SUB_REPOS_BASE_DIR)/why-openly-bipolar-people-should-not-be-medicated

$(OPENLY_BIPOLAR_DEST_PIVOT): $(OPENLY_BIPOLAR_SRC_DIR)/alan_turing.webp
	cp -f $(OPENLY_BIPOLAR_SRC_DIR)/*.webp $(OPENLY_BIPOLAR_DEST_DIR)/

$(DnD_lances_cartoon_DEST): $(SRC_SRC_DIR)/art/d-and-d-cartoon--comparing-lances/d-and-d-cartoon-exported.png
	$(call simple_gm)

all: $(DnD_lances_cartoon_DEST)

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

TECH_BLOG_DIR := $(SUB_REPOS_BASE_DIR)/shlomif-tech-diary
TECH_TIPS_SCRIPT := $(TECH_BLOG_DIR)/extract-tech-tips.pl
TECH_TIPS_INPUTS := $(addprefix $(TECH_BLOG_DIR)/,old-tech-diary.xhtml tech-diary.xhtml)
TECH_TIPS_OUT := $(SUB_REPOS_BASE_DIR)/shlomif-tech-diary--tech-tips.xhtml

$(TECH_TIPS_OUT): $(TECH_TIPS_SCRIPT) $(TECH_TIPS_INPUTS)
	$(PERL) $(TECH_TIPS_SCRIPT) $(addprefix --file=,$(TECH_TIPS_INPUTS)) --output $@ --nowrap

$(PRE_DEST)/open-source/resources/tech-tips/index.xhtml: $(TECH_TIPS_OUT)
all_deps: $(TECH_TIPS_OUT)

$(PRE_DEST)/philosophy/computers/web/validate-your-html/index.xhtml: $(SUB_REPOS_BASE_DIR)/validate-your-html/README.md
$(PRE_DEST)/philosophy/computers/how-to-share-code-for-getting-help/index.xhtml: $(SUB_REPOS_BASE_DIR)/how-to-share-code-online/README.md

all: $(SRC_CLEAN_STAMP)

PROC_INCLUDES_COMMON2 = APPLY_TEXTS=1 xargs $(PROCESS_ALL_INCLUDES__NON_INPLACE) --mode=minify --minifier-conf=bin/html-min-cli-config-file.conf --texts-dir=lib/ads --source-dir=$(1) --dest-dir=$(2) --
PROC_INCLUDES_COMMON := $(call PROC_INCLUDES_COMMON2,$(PRE_DEST),$(POST_DEST))

WMLect_PATH := lecture/WebMetaLecture/slides/examples

SKIP_EPUBS_NORMALIZE_DUE_TO_INVALID_EPUBS = 0

$(SRC_CLEAN_STAMP): $(BK2HP_NEW_PNG) $(DOCBOOK5_INSTALLED_EPUBS) $(FORTS_EPUB_DEST) $(FORTUNES_BUILT_TARGETS) $(MANIFEST_HTML) $(MATHJAX_DEST_README) $(POST_DEST_XZ_MODS) $(POST_DEST_ZIP_MODS) $(PRES_TARGETS_ALL_FILES) $(SCREENPLAY_XML__EPUBS_DESTS) $(SCREENPLAY_XML__RAW_HTMLS__DESTS) $(SPORK_LECTURES_DEST_STARTS) $(SRC_DOCS_DEST)
	$(call find_htmls,$(PRE_DEST)) | grep -vF -e philosophy/by-others/sscce -e WebMetaLecture/slides/examples -e homesteading/catb-heb -e $(SRC_SRC_DIR)/catb-heb.html | $(STRIP_src_dir_DEST) | $(PROC_INCLUDES_COMMON)
	rsync --exclude '*.html' --exclude '*.xhtml' -a $(PRE_DEST)/ $(POST_DEST)/
	if test "$(SKIP_EPUBS_NORMALIZE_DUE_TO_INVALID_EPUBS)" != "1" ; then find $(POST_DEST) -name '*.epub' -o -name '*.zip' | xargs -n 3 -P 8 $(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/normalize-zips.pl ; fi
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/gen-index-xhtmls-redirects.pl
	rsync -a $(PRE_DEST)/$(WMLect_PATH)/ $(POST_DEST)/$(WMLect_PATH)
	touch $@

docbook_extended: screenplays_pdfs

all_deps: $(christina_grimmie_letter_html)

FASTRENDER_DEPS := $(patsubst $(PRE_DEST)/%,$(SRC_SRC_DIR)/%.tt2,$(SRC_DOCS_DEST)) all_deps

include lib/make/pages-sects.mak

fastrender: fastrender-tt2 $(SRC_FORTUNES_ALL__HTML)

fastrender-tt2: $(FASTRENDER_DEPS)
	@echo $(MAKE) fastrender-tt2
	perl bin/tt-render.pl

copy_images_target: $(SRC_IMAGES_DEST) $(SRC_COMMON_IMAGES_DEST)

TEST_TARGETS := Tests/*.{py,t}

POST_DEST_FIERY_Q_PNG := $(POST_DEST_HUMOUR)/Star-Trek/We-the-Living-Dead/images/fiery-Q.png
CATB_COPY := $(PRE_DEST)/catb-heb.xhtml
CATB_COPY_POST := $(POST_DEST)/catb-heb.xhtml

include lib/make/copies-generated-include.mak
include lib/make/docbook/screenplays-copy-operations.mak
include lib/make/image-files.mak

minified_assets: $(SRC_SVGS__MIN) $(SRC_SVGS__svgz) $(BK2HP_SVG_SRC) $(SRC_rjpgs__webps) $(SRC_jpgs__webps) $(SRC_pngs__webps) $(MAIN_TOTAL_MIN_JS_DEST) $(TREE_JS_DEST) $(EXPANDER_MIN_JS_DEST) $(EXPANDER_JS_DEST)
screenplay_targets: $(SCREENPLAY_SOURCES_ON_POST_DEST__EXTRA_TARGETS)
docbook_targets: docbook_hhfg_images
docbook_targets: screenplay_targets

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

all_deps: $(JQUERYUI_JS_DESTS)
all_deps: $(JQUI_webpack_dest)
all_deps: $(SRC_IMAGES_DEST)

TEST_ENV = PYTHONPATH="$${PYTHONPATH}:$(LATEMP_ABS_ROOT_SOURCE_DIR)/Tests/lib"
SAMSMITHXML := $(DOCBOOK5_SOURCES_DIR)/samsmith.xml
SAMSMITHXML_SRC := $(SUB_REPOS_BASE_DIR)/shlomif-tech-diary/multiverse-cosmology-v0.4.x.db5.xml

$(SAMSMITHXML): $(SAMSMITHXML_SRC)
	python3 bin/extract-docbook5-node.py $< '//*[@xml:id="the-terran-terminators"]' > $@

.PHONY: bulk-make-dirs fortunes-compile-xmls install_docbook_css_dirs install_docbook_individual_xhtmls install_docbook_xmls make-dirs mod_files presentations_targets
