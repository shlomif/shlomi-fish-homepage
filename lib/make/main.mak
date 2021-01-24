POST_DEST := dest/post-incs/t2
LATEMP_ROOT_SOURCE_DIR := .
LATEMP_ABS_ROOT_SOURCE_DIR := $(shell cd $(LATEMP_ROOT_SOURCE_DIR)/ && pwd)

MATHJAX_SOURCE_README := lib/js/MathJax/README.md

all: all_deps non_latemp_targets

all_deps: sects_cache docbook_targets fortunes-epub fortunes-target copy_fortunes

non_latemp_targets: art_slogans_targets copy_images_target css_targets generate_nav_data_as_json htaccesses_target hhgg_convert lc_pres_targets mathjax_dest minified_assets mod_files mojo_pres plaintext_scripts_with_offending_extensions printable_resumes__html presentations_targets site_source_install svg_nav_images

include lib/make/shlomif_common.mak
include lib/make/include.mak

BK2HP_SVG_BASE := images/bk2hp-v2.svg
SRC_IMAGES += $(BK2HP_SVG_BASE)
REBOOKMAKER := rebookmaker

include lib/make/rules.mak

PRE_DEST := $(SRC_DEST)

include lib/factoids/deps.mak
include lib/make/factoids.mak
include lib/make/docbook/sf-fictions-list.mak
include lib/make/long_stories.mak

COMMON_POST_DEST_DIRS := $(addprefix $(POST_DEST)/,$(COMMON_DIRS))

BK2HP_SVG_SRC := $(SRC_SRC_DIR)/$(BK2HP_SVG_BASE)

POST_DEST_DIRS := $(addprefix $(POST_DEST)/,$(SRC_DIRS))

NAV_DATA_DEP := lib/MyNavData.pm
NAV_DATA_AS_JSON_BIN := bin/nav-data-as-json

SCREENPLAY_COMMON_INC_DIR := $(LATEMP_ABS_ROOT_SOURCE_DIR)/lib/screenplay-xml/from-vcs/screenplays-common

DOCS_COMMON_DEPS := $(NAV_DATA_DEP)

FORTUNES_DIR := humour/fortunes
SRC_FORTUNES_DIR := $(SRC_SRC_DIR)/$(FORTUNES_DIR)

include $(SRC_FORTUNES_DIR)/fortunes-list.mak

MANIFEST_HTML := $(PRE_DEST)/MANIFEST.html
GEN_SECT_NAV_MENUS := ./bin/gen-sect-nav-menus.pl
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
Evilphish_flipped_dest := $(POST_DEST)/images/evilphish-flipped.png

ALL_SUBSECTS_DEPS := $(ART_DEPS) $(HUMOUR_DEPS) $(LECTURES_DEPS) $(META_SUBSECT_DEPS) $(PHILOSOPHY_DEPS) $(PUZZLES_DEPS) $(SECTION_MENU_DEPS) $(SOFTWARE_DEPS)

FACTOIDS_NAV_JSON := lib/Shlomif/factoids-nav.json

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
all: $(POST_DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.xml
all: $(POST_DEST_POPE)/The-Pope-Died-on-Sunday-english.xml

SRC_SRC_FORTUNE_SHOW_SCRIPT := $(SRC_SRC_DIR)/$(FORTUNES_DIR)/show.cgi
FORTUNE_SHOW_PY__BN := fortunes_show.py
SRC_SRC_FORTUNE_SHOW_PY := $(SRC_SRC_DIR)/$(FORTUNES_DIR)/$(FORTUNE_SHOW_PY__BN)
SRC_SRC_BOTTLE := $(SRC_SRC_DIR)/$(FORTUNES_DIR)/bottle.py
POST_DEST_FORTUNE_SHOW_SCRIPT_TXT := $(POST_DEST_FORTUNES_DIR)/show-cgi.txt

htacc = $(addsuffix /.htaccess,$(1))
SRC_FORTUNES_DIR_HTACCESS := $(call htacc,$(PRE_DEST_FORTUNES_DIR))

ALL_HTACCESSES := $(call htacc,$(PRE_DEST_FORTUNES_DIR) $(addprefix $(PRE_DEST)/,lecture/PostgreSQL-Lecture))

htaccesses_target: $(ALL_HTACCESSES)

$(SRC_FORTUNES_DIR)/my_htaccess.conf: $(SRC_FORTUNES_DIR)/gen-htaccess.pl
	(cd $(SRC_FORTUNES_DIR) && gmake)

$(SRC_FORTUNES_ALL_TT2): $(LATEMP_ROOT_SOURCE_DIR)/bin/gen-forts-all-in-one-page.pl $(FORTUNES_LIST_PM)
	$(PERL) -I $(LATEMP_ROOT_SOURCE_DIR)/lib $< $@

PRE_DEST_FORTUNES := $(patsubst $(SRC_FORTUNES_DIR)/%,$(PRE_DEST_FORTUNES_DIR)/%,$(wildcard $(SRC_FORTUNES_DIR)/fortunes-shlomif-*.tar.gz))

chmod_copy = $(call COPY) ; chmod +x $@

$(SRC_SRC_FORTUNE_SHOW_PY): $(SRC_SRC_FORTUNE_SHOW_SCRIPT)
	$(call chmod_copy)

RSYNC_EXCLUDES := --exclude='**/js/MathJax/**'

ifeq ($(UPLOAD_MATHJAX),1)
	RSYNC_EXCLUDES :=
endif

UPLOAD = (cd $(POST_DEST) && $(RSYNC) $(RSYNC_EXCLUDES) -a . $1 )

upload_deps: all

upload_local: upload_deps
	$(call UPLOAD,$${HOMEPAGE_SSH_PATH})

upload: upload_local upload_remote_only

upload_remote_only: upload_deps
	$(call UPLOAD,$${__HOMEPAGE_REMOTE_PATH})

upload_remote_only_without_deps:
	$(call UPLOAD,$${__HOMEPAGE_REMOTE_PATH})

upload_var: upload_deps upload_var_without_deps

upload_var_without_deps:
	$(call UPLOAD,/var/www/html/shlomif/homepage-local/)

upload_beta: upload_deps
	$(call UPLOAD,$${__HOMEPAGE_REMOTE_PATH}/__Beta-kmor)

upload_beta2: upload_deps
	$(call UPLOAD,$${__HOMEPAGE_REMOTE_PATH}/__Beta-aj2del)

upload_all: upload upload_var upload_local upload_beta

upload_hostgator: upload_deps
	$(call UPLOAD,'hostgator:public_html/')

$(PRE_DEST)/open-source/projects/Spark/mission/index.xhtml : lib/docbook/5/rendered/Spark-Pre-Birth-of-a-Modern-Lisp.xhtml
$(PRE_DEST)/philosophy/Index/index.xhtml : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl

#### Humour thing

rss:
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/fetch-shlomif_hsite-feed.pl
	touch $(SRC_SRC_DIR)/index.xhtml.tt2 $(SRC_SRC_DIR)/old-news.html.tt2

prod_sync_inc = $(1)/include-me.html

PROD_SYND_MUSIC_DIR := $(LATEMP_ROOT_SOURCE_DIR)/lib/prod-synd/music
PROD_SYND_MUSIC_INC := $(call prod_sync_inc,$(PROD_SYND_MUSIC_DIR))

PROD_SYND_NON_FICTION_BOOKS_DIR := $(LATEMP_ROOT_SOURCE_DIR)/lib/prod-synd/non-fiction-books
PROD_SYND_NON_FICTION_BOOKS_INC := $(call prod_sync_inc,$(PROD_SYND_NON_FICTION_BOOKS_DIR))

PROD_SYND_FILMS_DIR := $(LATEMP_ROOT_SOURCE_DIR)/lib/prod-synd/films
PROD_SYND_FILMS_INC := $(call prod_sync_inc,$(PROD_SYND_FILMS_DIR))

$(PRE_DEST)/art/recommendations/music/index.xhtml: $(PROD_SYND_MUSIC_INC)

all_deps: $(PROD_SYND_MUSIC_INC)

GPERL = $(PERL) -I $(LATEMP_ROOT_SOURCE_DIR)/lib
GPERL_DEPS := $(LATEMP_ROOT_SOURCE_DIR)/lib/Shlomif/Homepage/Amazon/Obj.pm

$(PROD_SYND_MUSIC_INC) : $(PROD_SYND_MUSIC_DIR)/gen-prod-synd.pl $(SRC_SRC_DIR)/art/recommendations/music/shlomi-fish-music-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

$(PRE_DEST)/philosophy/books-recommends/index.xhtml : $(PROD_SYND_NON_FICTION_BOOKS_INC)

all_deps : $(PROD_SYND_NON_FICTION_BOOKS_INC)

$(PROD_SYND_NON_FICTION_BOOKS_INC) : $(PROD_SYND_NON_FICTION_BOOKS_DIR)/gen-prod-synd.pl $(SRC_SRC_DIR)/philosophy/books-recommends/shlomi-fish-non-fiction-books-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

$(PRE_DEST_HUMOUR)/recommendations/films/index.xhtml: $(PROD_SYND_FILMS_INC)

all_deps: $(PROD_SYND_FILMS_INC)

$(PROD_SYND_FILMS_INC) : $(PROD_SYND_FILMS_DIR)/gen-prod-synd.pl $(SRC_SRC_DIR)/humour/recommendations/films/shlomi-fish-films-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

SCREENPLAY_XML_BASE_DIR := lib/screenplay-xml
SCREENPLAY_XML_EPUB_DIR := $(SCREENPLAY_XML_BASE_DIR)/epub
SCREENPLAY_XML_XML_DIR := $(SCREENPLAY_XML_BASE_DIR)/xml
SCREENPLAY_XML_TXT_DIR := $(SCREENPLAY_XML_BASE_DIR)/txt
SCREENPLAY_XML_HTML_DIR := $(SCREENPLAY_XML_BASE_DIR)/html
SCREENPLAY_XML_RENDERED_HTML_DIR := $(SCREENPLAY_XML_BASE_DIR)/rendered-html

FICTION_XML_BASE_DIR := lib/fiction-xml
FICTION_XML_XML_DIR := $(FICTION_XML_BASE_DIR)/xml
FICTION_XML_TXT_DIR := $(FICTION_XML_BASE_DIR)/txt
FICTION_XML_DB5_XSLT_DIR := $(FICTION_XML_BASE_DIR)/docbook5-post-proc
FICTION_XML_TEMP_DB5_DIR := $(FICTION_XML_BASE_DIR)/intermediate-docbook5-results

include lib/make/docbook/sf-screenplays.mak

SCREENPLAY_DOCS_ADDITIONS := \
	ae-interview \
	Emma-Watson-applying-for-a-software-dev-job \
	Emma-Watson-visit-to-Israel-and-Gaza \
	hitchhikers-guide-to-star-trek-tng-hand-tweaked \
	humanity-excerpt-for-X-G-Screenplay-demo \
	Mighty-Boosh--Ape-of-Death--Scenes \
	sussman-interview

SCREENPLAY_DOCS := $(SCREENPLAY_DOCS_ADDITIONS) $(SCREENPLAY_DOCS_FROM_GEN)

FICTION_DOCS_ADDITIONS := \
	fiction-text-example-for-X-G-Fiction-demo \
	The-Enemy-Hebrew-rev6 \
	The-Enemy-Hebrew-v7

FICTION_DOCS := $(FICTION_DOCS_ADDITIONS) $(FICTION_DOCS_FROM_GEN)

SCREENPLAY_XMLS := $(patsubst %,$(SCREENPLAY_XML_XML_DIR)/%.xml,$(SCREENPLAY_DOCS))
FICTION_XMLS := $(patsubst %,$(FICTION_XML_XML_DIR)/%.xml,$(FICTION_DOCS_ADDITIONS))

all: splay

include lib/make/docbook/sf-homepage-quadpres-generated.mak

screenplay_docs = $(patsubst %,$(1)/%.$(2),$(SCREENPLAY_DOCS))

SCREENPLAY_RENDERED_HTMLS := $(call screenplay_docs,$(SCREENPLAY_XML_RENDERED_HTML_DIR),html)
SCREENPLAY_XML_HTMLS := $(call screenplay_docs,$(SCREENPLAY_XML_HTML_DIR),html)

splay: $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_XML_HTMLS)

$(SCREENPLAY_XML_HTML_DIR)/%.html: $(SCREENPLAY_XML_XML_DIR)/%.xml
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/screenplay-xml-to-html.pl -o $@ $<

$(SCREENPLAY_XML_RENDERED_HTML_DIR)/%.html: $(SCREENPLAY_XML_HTML_DIR)/%.html
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/extract-screenplay-xml-html.pl -o $@ $<

$(SCREENPLAY_XML_XML_DIR)/%.xml: $(SCREENPLAY_XML_TXT_DIR)/%.txt
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/screenplay-text-to-xml.pl -o $@ $<

POST_DEST_HUMOUR_SELINA := $(POST_DEST_HUMOUR)/Selina-Mandrake
POST_DEST_INTERVIEWS := $(POST_DEST)/open-source/interviews

POST_DEST_SPLAY_HHGG_STTNG := $(POST_DEST_HUMOUR)/by-others/hitchhiker-guide-to-star-trek-tng-hand-tweaked.txt

SCREENPLAY_SOURCES_ON_POST_DEST := $(POST_DEST_INTERVIEWS)/ae-interview.txt $(POST_DEST_INTERVIEWS)/sussman-interview.txt $(POST_DEST_SPLAY_HHGG_STTNG)

HHFG_DIR := $(POST_DEST_HUMOUR)/human-hacking
HHFG_HEB_V2_TXT := human-hacking-field-guide-hebrew-v2.txt
HHFG_HEB_V2_POST_DEST := $(HHFG_DIR)/$(HHFG_HEB_V2_TXT)
HHFG_HEB_V2_XSLT_POST_DEST := $(HHFG_DIR)/human-hacking-field-guide-hebrew-v2.db-postproc.xslt

FICTION_TEXT_SOURCES_ON_POST_DEST := $(POST_DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.txt $(HHFG_HEB_V2_POST_DEST) $(HHFG_HEB_V2_XSLT_POST_DEST) $(POST_DEST_POPE)/The-Pope-Died-on-Sunday-english.txt

translate_fiction_text_to_xml = $(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/fiction-text-to-xml.pl -o $@ $<

$(FICTION_XMLS): $(FICTION_XML_XML_DIR)/%.xml: $(FICTION_XML_TXT_DIR)/%.txt
	$(call translate_fiction_text_to_xml)

HHGG_CONVERT_SCRIPT_FN := convert-hitchhiker-guide-to-st-tng-to-screenplay-xml.pl
HHGG_CONVERT_SCRIPT_SRC := $(LATEMP_ROOT_SOURCE_DIR)/bin/processors/$(HHGG_CONVERT_SCRIPT_FN)
HHGG_CONVERT_SCRIPT_DEST := $(PRE_DEST_HUMOUR)/by-others/$(HHGG_CONVERT_SCRIPT_FN).txt

hhgg_convert: $(HHGG_CONVERT_SCRIPT_DEST)

FRON_IMAGE_BASE := fron-demon-illustration-small-indexed.png
SELINA_MANDRAKE_ENG_FRON_IMAGE__SOURCE := $(SELINA_MANDRAKE__VCS_DIR)/graphics/fron/$(FRON_IMAGE_BASE)
SELINA_MANDRAKE_ENG_FRON_IMAGE__POST_DEST := $(POST_DEST_HUMOUR_SELINA)/images/$(FRON_IMAGE_BASE)

QOHELETH_IMAGES__BASE := Friends-S02E04--Nothing-Sexier.svg.jpg If-You-Wanna-Be-Sad.svg.jpg Standup-Philosopher.svg.webp sigourney-weaver--resized.jpg summer-glau--two-guns--400w.jpg

QOHELETH_IMAGES__SOURCE_PREFIX := $(SO_WHO_THE_HELL_IS_QOHELETH__VCS_DIR)/graphics
QOHELETH_IMAGES__POST_DEST_PREFIX := $(POST_DEST_HUMOUR)/So-Who-The-Hell-Is-Qoheleth/images

QOHELETH_IMAGES__SOURCE := $(addprefix $(QOHELETH_IMAGES__SOURCE_PREFIX)/,$(QOHELETH_IMAGES__BASE))
QOHELETH_IMAGES__POST_DEST := $(addprefix $(QOHELETH_IMAGES__POST_DEST_PREFIX)/,$(QOHELETH_IMAGES__BASE))


QUEEN_PADME_TALES_IMAGES__BASE := Christina_Grimmie_in_November_2014--resized.webp bad-blood189.webp evilphish-svg--facing-right.min.svg.png tacos6306095903_a5c92746ba_o--tacos-reduced-by-jeffreyw--small-400px.webp

QUEEN_PADME_TALES_IMAGES__SOURCE_PREFIX := $(QUEEN_PADME_TALES__VCS_DIR)/graphics
QUEEN_PADME_TALES_IMAGES__POST_DEST_PREFIX := $(POST_DEST_HUMOUR)/Queen-Padme-Tales/images

QUEEN_PADME_TALES_IMAGES__SOURCE := $(addprefix $(QUEEN_PADME_TALES_IMAGES__SOURCE_PREFIX)/,$(QUEEN_PADME_TALES_IMAGES__BASE))
QUEEN_PADME_TALES_IMAGES__POST_DEST := $(addprefix $(QUEEN_PADME_TALES_IMAGES__POST_DEST_PREFIX)/,$(QUEEN_PADME_TALES_IMAGES__BASE))


TERM_LIBERATION_IMAGES__BASE := emma-watson-wandless.svg.webp
TERM_LIBERATION_IMAGES__SOURCE_PREFIX := $(TERMINATOR_LIBERATION__VCS_DIR)/graphics
TERM_LIBERATION_IMAGES__POST_DEST_PREFIX := $(POST_DEST_HUMOUR)/Terminator/Liberation/images

TERM_LIBERATION_IMAGES__SOURCE := $(addprefix $(TERM_LIBERATION_IMAGES__SOURCE_PREFIX)/,$(TERM_LIBERATION_IMAGES__BASE))
TERM_LIBERATION_IMAGES__POST_DEST := $(addprefix $(TERM_LIBERATION_IMAGES__POST_DEST_PREFIX)/,$(TERM_LIBERATION_IMAGES__BASE))

$(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng.txt : $(HHGG_CONVERT_SCRIPT_SRC) $(SRC_SRC_DIR)/humour/by-others/hitchhiker-guide-to-star-trek-tng.txt
	$(PERL) $<

screenplay_epub_dests: $(SCREENPLAY_XML__EPUBS_DESTS)

# Rebuild the embedded docbook4 pages in the $(PRE_DEST) after they are
# modified.

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
all_deps: $(SRC_FORTUNES_ALL_TT2)

all: $(PUT_CARDS_2013_DEST) $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)

$(PRE_DEST)/philosophy/philosophy/putting-all-cards-on-the-table-2013/index.xhtml : $(PUT_CARDS_2013_XHTML_STRIPPED)

# Rebuild the pages containing the links to $(SRC_SRC_DIR)/humour/stories upon changing
# the lib/stories.

$(PRE_DEST_HUMOUR)/index.xhtml $(PRE_DEST_HUMOUR)/stories/index.xhtml $(PRE_DEST_HUMOUR)/stories/Star-Trek/index.xhtml $(PRE_DEST_HUMOUR)/stories/Star-Trek/We-the-Living-Dead/index.xhtml $(PRE_DEST_HUMOUR)/TheEnemy/index.xhtml: lib/stories/stories-list.tt2

$(PRE_DEST_HUMOUR)/humanity/index.xhtml $(PRE_DEST_HUMOUR)/humanity/ongoing-text.html $(PRE_DEST_HUMOUR)/humanity/buy-the-fish-in-hebrew.html $(PRE_DEST_HUMOUR)/humanity/ongoing-text-hebrew.html : lib/stories/blurbs.tt2

FORTUNES_XHTMLS_DIR := lib/fortunes/xhtmls

FORTUNES_LIST_PM := lib/Shlomif/Homepage/FortuneCollections.pm
FORTUNES_LIST__DEPS := $(FORTUNES_LIST_PM) lib/Shlomif/fortunes-meta-data.yml

FORTUNES_XMLS_BASE := $(addsuffix .xml,$(FORTUNES_FILES_BASE))
FORTUNES_XMLS_SRC := $(addprefix $(SRC_FORTUNES_DIR)/,$(FORTUNES_XMLS_BASE))
FORTUNES_XHTMLS := $(patsubst $(SRC_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_XHTMLS_TOCS := $(patsubst $(SRC_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.toc-xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_SOURCE_TT2S := $(patsubst %,$(SRC_FORTUNES_DIR)/%.html.tt2,$(FORTUNES_FILES_BASE))
FORTUNES_DEST_HTMLS := $(patsubst $(SRC_FORTUNES_DIR)/%.html.tt2,$(PRE_DEST_FORTUNES_DIR)/%.html,$(FORTUNES_SOURCE_TT2S))
FORTUNES_XHTMLS__COMPRESSED := $(patsubst %.xhtml,%.compressed.xhtml,$(FORTUNES_XHTMLS))
FORTUNES_XHTMLS__FOR_INPUT_PORTIONS := $(patsubst %.xhtml,%.xhtml-for-input,$(FORTUNES_XHTMLS))
FORTUNES_TT2S_HTMLS := $(patsubst %,$(PRE_DEST_FORTUNES_DIR)/%.html,$(FORTUNES_FILES_BASE))
FORTUNES_TEXTS := $(patsubst %.xml,%,$(FORTUNES_XMLS_SRC))
FORTUNES_DATS := $(patsubst %.xml,%.dat,$(FORTUNES_XMLS_SRC))
FORTUNES__SHOW_PY__PRE_DEST := $(PRE_DEST_FORTUNES_DIR)/$(FORTUNE_SHOW_PY__BN) $(PRE_DEST_FORTUNES_DIR)/show.cgi
FORTUNES_ATOM_FEED := $(PRE_DEST_FORTUNES_DIR)/fortunes-shlomif-all.atom
FORTUNES_RSS_FEED := $(PRE_DEST_FORTUNES_DIR)/fortunes-shlomif-all.rss
FORTUNES_SQLITE_BASENAME := fortunes-shlomif-lookup.sqlite3
POST_DEST_FORTUNES_SQLITE_DB := $(POST_DEST_FORTUNES_DIR)/$(FORTUNES_SQLITE_BASENAME)
FORTUNES_SQLITE_DB := $(SRC_FORTUNES_DIR)/$(FORTUNES_SQLITE_BASENAME)

FORTS_EPUB_BASENAME := fortunes-shlomif.epub
FORTS_EPUB_DEST := $(PRE_DEST_FORTUNES_DIR)/$(FORTS_EPUB_BASENAME)
FORTUNES_TEXTS__PRE_DEST := $(patsubst $(SRC_SRC_DIR)/%,$(PRE_DEST)/%,$(FORTUNES_TEXTS))
FORTUNES_DATS__PRE_DEST := $(patsubst $(SRC_SRC_DIR)/%,$(PRE_DEST)/%,$(FORTUNES_DATS))

FORTUNES_BUILT_TARGETS := $(FORTUNES_SOURCE_TT2S) $(FORTUNES_XHTMLS) $(FORTUNES_XHTMLS__COMPRESSED) $(FORTUNES_TEXTS) $(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED) $(FORTUNES_SQLITE_DB) $(FORTUNES__SHOW_PY__PRE_DEST) $(FORTUNES_TEXTS__PRE_DEST) $(FORTUNES_DATS__PRE_DEST)

fortunes-compile-xmls: $(FORTUNES_BUILT_TARGETS)

FORTUNES_CONVERT_TO_XHTML_SCRIPT := $(SRC_FORTUNES_DIR)/convert-to-xhtml.pl
FORTUNES_PREPARE_FOR_INPUT_SCRIPT := $(SRC_FORTUNES_DIR)/prepare-xhtml-for-input.pl

$(FORTUNES__SHOW_PY__PRE_DEST): %: $(SRC_SRC_FORTUNE_SHOW_PY)
	$(call chmod_copy)

$(FORTUNES_SOURCE_TT2S): $(FORTUNES_LIST__DEPS)
	$(PERL) -I $(LATEMP_ROOT_SOURCE_DIR)/lib -MShlomif::Homepage::FortuneCollections -e 'Shlomif::Homepage::FortuneCollections->new->print_all_fortunes_html_tt2s;'

$(FORTUNES_XHTMLS__FOR_INPUT_PORTIONS): %.xhtml-for-input: %.compressed.xhtml $(FORTUNES_PREPARE_FOR_INPUT_SCRIPT)
	$(PERL) $(FORTUNES_PREPARE_FOR_INPUT_SCRIPT) $< $@

$(FORTUNES_XHTMLS): $(FORTUNES_XHTMLS_DIR)/%.xhtml : $(SRC_FORTUNES_DIR)/%.xml $(FORTUNES_CONVERT_TO_XHTML_SCRIPT)
	$(PERL) $(FORTUNES_CONVERT_TO_XHTML_SCRIPT) $< $@

FORTUNES_XML_TO_XHTML_TOC_XSLT := lib/fortunes/fortune-xml-to-xhtml-toc.xslt

$(FORTUNES_XHTMLS_TOCS): $(FORTUNES_XHTMLS_DIR)/%.toc-xhtml : $(SRC_FORTUNES_DIR)/%.xml $(FORTUNES_XML_TO_XHTML_TOC_XSLT)
	xsltproc $(FORTUNES_XML_TO_XHTML_TOC_XSLT) $< | \
	$(PERL) -0777 -lapE 's#\A.*?<ul[^>]*?>#<ul>#ms; s#^[ \t]+##gms; s#[ \t]+$$##gms' - > \
	$@

$(FORTUNES_TT2S_HTMLS): $(PRE_DEST_FORTUNES_DIR)/%.html: $(FORTUNES_XHTMLS_DIR)/%.xhtml-for-input

FORTUNES_TIDY := tidy -asxhtml -utf8 -quiet --tidy-mark no

$(FORTUNES_XHTMLS__COMPRESSED): %.compressed.xhtml: %.xhtml
	$(FORTUNES_TIDY) --show-warnings no -o $@ $< || true

$(FORTUNES_TEXTS): $(SRC_FORTUNES_DIR)/%: $(SRC_FORTUNES_DIR)/%.xml
	$(PERL) $(SRC_FORTUNES_DIR)/validate-and-convert-to-plaintext.pl $< $@

$(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED): $(SRC_FORTUNES_DIR)/generate-web-feeds.pl $(FORTUNES_XMLS_SRC)
	$(PERL) $< --atom $(FORTUNES_ATOM_FEED) --rss $(FORTUNES_RSS_FEED) --dir $(SRC_FORTUNES_DIR)

$(FORTUNES_SQLITE_DB): $(SRC_FORTUNES_DIR)/populate-sqlite-database.pl $(FORTUNES_XHTMLS__COMPRESSED) $(FORTUNES_LIST__DEPS) $(FORTUNES_TEXTS__PRE_DEST)
	$(PERL) -I $(LATEMP_ROOT_SOURCE_DIR)/lib $<

$(FORTUNES_TARGET): $(SRC_FORTUNES_DIR)/index.xhtml.tt2 $(DOCS_COMMON_DEPS) $(HUMOUR_DEPS) $(SRC_FORTUNES_DIR)/Makefile $(SRC_FORTUNES_DIR)/ver.txt

# TODO : extract a macro for this and the rule below.
$(FORTUNES_DEST_HTMLS): $(PRE_DEST_FORTUNES_DIR)/%.html: lib/fortunes/xhtmls/%.toc-xhtml lib/fortunes/xhtmls/%.xhtml $(DOCS_COMMON_DEPS)

$(SRC_FORTUNES_ALL__TEMP__HTML): $(SRC_FORTUNES_ALL_TT2) $(DOCS_COMMON_DEPS) $(FORTUNES_XHTMLS__FOR_INPUT_PORTIONS) $(FORTUNES_XHTMLS_TOCS)

$(PRE_DEST_HUMOUR)/fortunes/index.xhtml: $(FORTUNES_LIST__DEPS)

FORTS_EPUB_COVER_PNG := $(FORTUNES_XHTMLS_DIR)/shlomif-fortunes.png
FORTS_EPUB_COVER_JPG := $(FORTUNES_XHTMLS_DIR)/shlomif-fortunes.jpg
FORTS_EPUB_COVER_SVG := $(FORTUNES_XHTMLS_DIR)/shlomif-fortunes.svg
FORTS_EPUB_ALL_COVERS := $(FORTS_EPUB_COVER_JPG) $(FORTS_EPUB_COVER_PNG) $(FORTS_EPUB_COVER_SVG)

$(FORTS_EPUB_DEST): $(FORTUNES_XHTMLS) $(FORTUNES_XHTMLS_TOCS) $(FORTS_EPUB_ALL_COVERS)
	export SCREENPLAY_COMMON_INC_DIR="$(SCREENPLAY_COMMON_INC_DIR)" DFN="$(PWD)/$(FORTS_EPUB_DEST)" ; echo $(patsubst $(FORTUNES_XHTMLS_DIR)/%.xhtml,%.xhtml,$(FORTUNES_XHTMLS)) | $(call PROC_INCLUDES_COMMON2,$(FORTUNES_XHTMLS_DIR),$(FORTUNES_XHTMLS_DIR)) ; cd $(FORTUNES_XHTMLS_DIR) && $(REBOOKMAKER) --output "$$DFN" "book.json"

fortunes-epub: $(FORTS_EPUB_DEST)

fortunes-target: $(FORTUNES_TARGET) fortunes-compile-xmls $(POST_DEST_FORTUNE_SHOW_SCRIPT_TXT) $(FORTUNES_DEST_HTMLS) $(FORTS_EPUB_ALL_COVERS)

INKSCAPE_WRAPPER = ./bin/inkscape-wrapper

simple_gm = gm convert $< $@
OPTIPNG := optipng -quiet

$(FORTS_EPUB_COVER_JPG): $(FORTS_EPUB_COVER_PNG)
	$(call simple_gm)

$(FORTS_EPUB_COVER_PNG): $(FORTS_EPUB_COVER_SVG)
	$(INKSCAPE_WRAPPER) --export-width=600 --export-type=png --export-filename="$@" $< && \
	$(OPTIPNG) $@

MOJOLICIOUS_LECTURE_SLIDE1 := $(PRE_DEST)/lecture/Perl/Lightning/Mojolicious/mojolicious-slides.html

HACKING_DOC := $(PRE_DEST)/open-source/resources/how-to-contribute-to-my-projects/HACKING.html

mojo_pres: $(MOJOLICIOUS_LECTURE_SLIDE1) $(HACKING_DOC)

define ASCIIDOCTOR_TO_XTHML5
	asciidoctor --backend=xhtml5 -o $@ $<
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/clean-up-asciidoctor-xhtml5.pl $@
endef

$(MOJOLICIOUS_LECTURE_SLIDE1): $(SRC_SRC_DIR)/lecture/Perl/Lightning/Mojolicious/mojolicious.asciidoc.txt
	$(call ASCIIDOCTOR_TO_XTHML5)

$(HACKING_DOC): $(SRC_SRC_DIR)/open-source/resources/how-to-contribute-to-my-projects/HACKING.txt
	$(call ASCIIDOCTOR_TO_XTHML5)

all_deps: lib/htmls/The-Enemy-rev5.html-part

EXTRACT_html_script := $(LATEMP_ROOT_SOURCE_DIR)/bin/extract-xhtml.pl
extract_gzipped_xhtml = gunzip < $< | $(PERL) $(EXTRACT_html_script) -o $@ -

lib/htmls/The-Enemy-rev5.html-part: $(SRC_SRC_DIR)/humour/TheEnemy/The-Enemy-Hebrew-rev5.xhtml.gz $(EXTRACT_html_script)
	$(call extract_gzipped_xhtml)

all_deps: lib/htmls/The-Enemy-English-rev5.html-part

lib/htmls/The-Enemy-English-rev5.html-part: $(SRC_SRC_DIR)/humour/TheEnemy/The-Enemy-English-rev5.xhtml.gz $(EXTRACT_html_script)
	$(call extract_gzipped_xhtml)

all_deps: lib/htmls/The-Enemy-English-rev6.html-part

lib/htmls/The-Enemy-English-rev6.html-part: $(SRC_SRC_DIR)/humour/TheEnemy/The-Enemy-English-rev6.xhtml.gz $(EXTRACT_html_script)
	$(call extract_gzipped_xhtml)

DOCBOOK5_HHFG_IMAGES_RAW := \
	background-image.png \
	background-shlomif.png \
	bottom-shlomif.png \
	hhfg-bg-bottom.png \
	hhfg-bg-middle.png \
	hhfg-bg-top.png \
	style.css \
	top-shlomif.png

DOCBOOK5_HHFG_DEST_DIR := $(PRE_DEST_HUMOUR)/human-hacking/human-hacking-field-guide
DOCBOOK5_HHFG_POST_DEST_DIR := $(POST_DEST_HUMOUR)/human-hacking/human-hacking-field-guide

HHFG_V2_IMAGES_DEST_DIR_FROM_VCS := $(PRE_DEST_HUMOUR)/human-hacking/human-hacking-field-guide-v2--english
HHFG_V2_IMAGES_DEST_DIR := $(PRE_DEST_HUMOUR)/human-hacking/human-hacking-field-guide-v2

HHFG_V2_IMAGES_POST_DEST_DIR_FROM_VCS := $(POST_DEST_HUMOUR)/human-hacking/human-hacking-field-guide-v2--english
HHFG_V2_IMAGES_POST_DEST_DIR := $(POST_DEST_HUMOUR)/human-hacking/human-hacking-field-guide-v2
HHFG_V2_IMAGES_POST_DEST := $(addprefix $(HHFG_V2_IMAGES_POST_DEST_DIR)/,$(DOCBOOK5_HHFG_IMAGES_RAW))
HHFG_V2_IMAGES_POST_DEST_FROM_VCS := $(addprefix $(HHFG_V2_IMAGES_POST_DEST_DIR_FROM_VCS)/,$(DOCBOOK5_HHFG_IMAGES_RAW))
HHFG_V2_DOCBOOK_css := $(HHFG_V2_IMAGES_POST_DEST_DIR)/docbook.css
DOCBOOK5_HHFG_IMAGES_POST_DEST := $(addprefix $(DOCBOOK5_HHFG_POST_DEST_DIR)/,$(DOCBOOK5_HHFG_IMAGES_RAW))

docbook_hhfg_images:  $(HHFG_V2_IMAGES_POST_DEST) $(HHFG_V2_IMAGES_POST_DEST_FROM_VCS) $(HHFG_V2_DOCBOOK_css) $(DOCBOOK5_HHFG_IMAGES_POST_DEST)

$(HHFG_V2_DOCBOOK_css): lib/docbook/5/indiv-nodes/human-hacking-field-guide-v2--english/docbook.css
	mkdir -p $(HHFG_V2_IMAGES_POST_DEST_DIR)
	cp -f $< $@

$(HHFG_V2_IMAGES_DEST_DIR)/index.xhtml: $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/index.xhtml
	mkdir -p $(HHFG_V2_IMAGES_DEST_DIR)
	cp -a $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/*.xhtml $(HHFG_V2_IMAGES_DEST_DIR)/

DOCBOOK5_DOCS += $(FICTION_DOCS)

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

FICTION_DB5S := $(patsubst %,$(DOCBOOK5_XML_DIR)/%.xml,$(FICTION_DOCS))
C_BAD_ELEMS_SRC := lib/c-begin/C-and-CPP-elements-to-avoid/c-and-cpp-elements-to-avoid.xml-grammar-vered.xml
POST_DEST__C_BAD_ELEMS := $(POST_DEST)/lecture/C-and-CPP/bad-elements/c-and-cpp-elements-to-avoid.xml-grammar-vered.xml

$(DOCBOOK5_SOURCES_DIR)/c-and-cpp-elements-to-avoid.xml: $(C_BAD_ELEMS_SRC)
	./bin/translate-Vered-XML --output "$@" "$<"

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

define EXPORT_INKSCAPE_PNG
	$(INKSCAPE_WRAPPER) --export-width=200 --export-type=png --export-filename="$@" $<
	$(OPTIPNG) $@
endef

define ASCIIDOCTOR_TO_DOCBOOK5
	asciidoctor --backend=docbook5 -o >(xsltproc bin/clean-up-asciidoctor-docbook5.xslt - > $@) $<
endef

PRINTER_ICON_PNG := $(POST_DEST)/images/printer_icon.png
TWITTER_ICON_20_PNG := $(POST_DEST)/images/twitter-bird-light-bgs-20.png
HHFG_SMALL_BANNER_AD_PNG := $(POST_DEST_HUMOUR)/human-hacking/images/hhfg-ad-468x60.svg.preview.png

BK2HP_NEW_PNG := $(POST_DEST)/images/bk2hp.png

POST_DEST_HTML_6_LOGO_PNG := $(POST_DEST_HUMOUR)/bits/HTML-6/HTML-6-logo.png

$(BK2HP_NEW_PNG): lib/images/back_to_my_homepage_from_inkscape.png
	gm convert -matte -bordercolor none -border 5 $< $@
	$(OPTIPNG) $@

art_slogans_targets: $(ART_SLOGANS_THUMBS) $(BUFFY_A_FEW_GOOD_SLAYERS__SMALL_LOGO_PNG) $(THE_ENEMY_SMALL_LOGO_PNG) $(HHFG_SMALL_BANNER_AD_PNG) $(PRINTER_ICON_PNG) $(TWITTER_ICON_20_PNG) $(BK2HP_NEW_PNG) $(POST_DEST_HTML_6_LOGO_PNG)

$(POST_DEST_HTML_6_LOGO_PNG): $(SRC_SRC_DIR)/humour/bits/HTML-6/HTML-6-logo.svg
	$(INKSCAPE_WRAPPER) --export-dpi=60 --export-area-page --export-type=png --export-filename="$@" "$<"
	$(OPTIPNG) $@

POST_DEST_WINDOWS_UPDATE_SNAIL_ICON := $(POST_DEST_HUMOUR)/bits/facts/images/windows-update-snail.png

all: $(POST_DEST_WINDOWS_UPDATE_SNAIL_ICON) $(POST_DEST_FIERY_Q_PNG)

$(POST_DEST_WINDOWS_UPDATE_SNAIL_ICON): $(SRC_SRC_DIR)/humour/bits/facts/images/snail.svg
	$(INKSCAPE_WRAPPER) --export-width=200 --export-type=png --export-filename="$@" $<
	$(OPTIPNG) $@

$(ART_SLOGANS_PNGS): %.png: %.svg
	$(INKSCAPE_WRAPPER) --export-type=png --export-filename=$@ $<
	$(OPTIPNG) $@

$(ART_SLOGANS_THUMBS): %.thumb.png: %.png
	gm convert -resize '200' $< $@
	$(OPTIPNG) $@

$(PRINTER_ICON_PNG): common/images/printer_icon.svg
	$(INKSCAPE_WRAPPER) --export-width=30 --export-type=png --export-filename="$@" $<
	$(OPTIPNG) $@

$(TWITTER_ICON_20_PNG): common/images/twitter-bird-light-bgs.svg
	$(INKSCAPE_WRAPPER) --export-width=30 --export-type=png --export-filename="$@" $<
	$(OPTIPNG) $@

$(HHFG_SMALL_BANNER_AD_PNG): $(SRC_SRC_DIR)/humour/human-hacking/images/hhfg-ad-468x60.svg.png
	gm convert -resize '50%' $< $@
	$(OPTIPNG) $@

LC_PRES_PATH := lecture/Lambda-Calculus/slides

LC_PRES_SCMS := \
	cond_funcs_loops.scm \
	cond.scm \
	funcs.scm \
	lc_bool_ops.scm \
	lc_bools_conds_tuples.scm \
	lc_church_div_old.scm \
	lc_church_div.scm \
	lc_church_ops.scm \
	lc_church.scm \
	lc_constructs.scm \
	lc_intro.scm \
	lc_recursion.scm \
	lc_Y.scm \
	lists.scm \
	loops.scm \
	notes.scm \
	output_vars.scm \
	shriram.scm \

LC_PRES_SRC_DIR := $(SRC_SRC_DIR)/$(LC_PRES_PATH)
LC_PRES_DEST := $(PRE_DEST)/$(LC_PRES_PATH)

# LC_PRES_DEST_HTMLS := $(patsubst %.scm,$(PRE_DEST)/$(LC_PRES_PATH)/%.scm.html,$(LC_PRES_SCMS))
LC_PRES_SRC_SCMS := $(patsubst %,$(LC_PRES_SRC_DIR)/%,$(LC_PRES_SCMS))
LC_PRES_DEST_HTMLS__PIVOT := $(patsubst %.scm,$(LC_PRES_DEST)/%.scm.html,notes.scm)

lc_pres_targets: $(LC_PRES_DEST_HTMLS__PIVOT)

# Uses text-vimcolor from http://search.cpan.org/dist/Text-VimColor/
$(LC_PRES_DEST_HTMLS__PIVOT): $(LC_PRES_SRC_SCMS)
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/text-vimcolor-multi.pl $(LC_PRES_SRC_DIR) $(LC_PRES_DEST)

SPORK_LECTURES_BASENAMES := \
	Perl/Graham-Function \
	Perl/Lightning/Opt-Multi-Task-in-PDL \
	Perl/Lightning/Test-Run \
	Perl/Lightning/Too-Many-Ways \
	SCM/subversion/for-pythoneers \
	Vim/beginners \

START_html := /start.html
SLIDES_start := /slides$(START_html)
SPORK_LECTS_SOURCE_BASE := lib/presentations/spork
GFUNC_PRES_BASE := $(SPORK_LECTS_SOURCE_BASE)/Perl/Graham-Function
GFUNC_PRES_DEST := $(PRE_DEST)/lecture/Perl/Graham-Function
GFUNC_PRES_BASE_START := $(GFUNC_PRES_BASE)$(SLIDES_start)
GFUNC_PRES_DEST_START := $(GFUNC_PRES_DEST)$(SLIDES_start)

SPORK_LECTURES_DESTS := $(addprefix $(PRE_DEST)/lecture/,$(SPORK_LECTURES_BASENAMES))
SPORK_LECTURES_DEST_STARTS := $(addsuffix $(SLIDES_start),$(SPORK_LECTURES_DESTS))
SPORK_LECTURES_BASE_STARTS := $(patsubst %,$(SPORK_LECTS_SOURCE_BASE)/%$(SLIDES_start),$(SPORK_LECTURES_BASENAMES))

SPORK_test_run_dir := $(SPORK_LECTS_SOURCE_BASE)/Perl/Lightning/Test-Run/slides/images
SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES__test_run := $(SPORK_test_run_dir)/screenshot02.png \
	$(SPORK_test_run_dir)/Test-Run-Plugin-ColorSummary.png

SPORK_too_many_ways_dir := $(SPORK_LECTS_SOURCE_BASE)/Perl/Lightning/Too-Many-Ways/slides/images
SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES__too_many := \
	$(SPORK_too_many_ways_dir)/coachella-crowd.jpg \
	$(SPORK_too_many_ways_dir)/coachella-crowd.webp \
	$(SPORK_too_many_ways_dir)/bono.jpg \
	$(SPORK_too_many_ways_dir)/TestBeforeYouTouchCARD.jpg

src/images/presentations/coachella-crowd.webp: %.webp: %.jpg
	$(call simple_gm)

SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES := $(SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES__too_many) $(SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES__test_run)

presentations_targets: $(SPORK_LECTURES_DEST_STARTS)

start_html = $(patsubst %$(START_html),%/,$1)

$(SPORK_LECTURES_DEST_STARTS) : $(PRE_DEST)/lecture/%$(START_html): $(SPORK_LECTS_SOURCE_BASE)/%$(START_html)
	rsync -a $(call start_html,$<) $(call start_html,$@)

$(SPORK_LECTURES_BASE_STARTS) : $(SPORK_LECTS_SOURCE_BASE)/%$(SLIDES_start) : $(SPORK_LECTS_SOURCE_BASE)/%/Spork.slides $(SPORK_LECTS_SOURCE_BASE)/%/config.yaml $(SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES)
	dn="$(patsubst %$(SLIDES_start),%,$@)" ; \
	   (cd "$$dn" && $(PERL) $(LATEMP_ABS_ROOT_SOURCE_DIR)/bin/my-spork.pl -- -make) && \
	cp -f common/favicon.png $(patsubst %$(START_html),%,$@)/

lib/presentations/spork/Vim/beginners/Spork.slides: lib/presentations/spork/Vim/beginners/Spork.slides.source
	< $< $(PERL) -pe 's!^\+!!' > $@

GEN_STYLE_CSS_FILES := \
cats-photos.css faq-indiv.css fort_total.css fortunes.css fortunes_show.css jqui-override.css print.css screenplay.css slash-humour.css style-404.css style.css

SRC_CSS_TARGETS := $(addprefix $(POST_DEST)/,$(GEN_STYLE_CSS_FILES))

css_targets: $(SRC_CSS_TARGETS)

SASS_STYLE := compressed
# SASS_STYLE := expanded
SASS_CMD := sass --style $(SASS_STYLE)

FORT_SASS_DEPS := lib/sass/fortunes.scss
COMMON_SASS_DEPS := lib/sass/common-body.scss lib/sass/common-style--bottom-imports.scss lib/sass/common-style-main.scss lib/sass/common-style.scss lib/sass/defs.scss lib/sass/mixins.scss

$(SRC_CSS_TARGETS): $(POST_DEST)/%.css: lib/sass/%.scss $(COMMON_SASS_DEPS)
	$(SASS_CMD) $< $@

$(POST_DEST)/style.css $(POST_DEST)/print.css: $(COMMON_SASS_DEPS) lib/sass/lang_switch.scss $(FORT_SASS_DEPS) lib/sass/code_block.scss lib/sass/jqtree.scss lib/sass/treeview.scss lib/sass/common-with-print.scss lib/sass/self_link.scss

$(POST_DEST)/style.css: lib/sass/footer.scss

$(POST_DEST)/fortunes_show.css: $(COMMON_SASS_DEPS)

$(POST_DEST)/fort_total.css: $(FORT_SASS_DEPS) lib/sass/fortunes.scss lib/sass/fortunes_show.scss $(COMMON_SASS_DEPS) lib/sass/screenplay.scss

$(PRE_DEST)/personal.html $(PRE_DEST)/personal-heb.html: lib/pages/t2/personal.tt2
$(PRE_DEST)/humour.html $(PRE_DEST)/humour-heb.html: lib/pages/t2/humour.tt2
$(PRE_DEST)/work/hire-me/index.xhtml $(PRE_DEST)/work/hire-me/hebrew.html: lib/pages/t2/hire-me.tt2

docbook_targets: pope_fiction selina_mandrake hhfg_fiction

$(PRE_DEST)/lecture/Perl/Newbies/lecture5-heb-notes.html: $(SRC_SRC_DIR)/lecture/Perl/Newbies/lecture5-notes.txt

$(PRE_DEST)/philosophy/by-others/perlcast-transcript--tom-limoncelli-interview/index.xhtml: lib/htmls/from-mediawiki/processed/Perlcast_Transcript_-_Interview_with_Tom_Limoncelli.html

HTML_TUT_BASE := lib/presentations/docbook/html-tutorial/hebrew-html-tutorial

HTML_TUT_HEB_DIR := $(HTML_TUT_BASE)/hebrew-html-tutorial
HTML_TUT_HEB_DB := $(HTML_TUT_BASE)/hebrew-html-tutorial.xml
HTML_TUT_HEB_TT := $(HTML_TUT_BASE)/hebrew-html-tutorial.xml.tt
PRE_DEST_HTML_TUT_BASE := $(PRE_DEST)/lecture/HTML-Tutorial/v1/xhtml1/hebrew
PRE_DEST_HTML_TUT := $(PRE_DEST_HTML_TUT_BASE)/index.xhtml

selina_mandrake: $(SELINA_MANDRAKE_ENG_SCREENPLAY_XML_SOURCE) $(SELINA_MANDRAKE_ENG_TXT_FROM_VCS) $(SELINA_MANDRAKE_ENG_FRON_IMAGE__POST_DEST) $(QOHELETH_IMAGES__POST_DEST) $(QUEEN_PADME_TALES_IMAGES__POST_DEST) $(TERM_LIBERATION_IMAGES__POST_DEST)

pope_fiction: $(POPE_ENG_FICTION_XML_SOURCE)

hhfg_fiction: $(HHFG_ENG_DOCBOOK5_SOURCE) $(HHFG_HEB_FICTION_XML_SOURCE)

QUEEN_PADME_TALES__teaser_dir := $(POST_DEST_HUMOUR)/Queen-Padme-Tales/teaser
QUEEN_PADME_TALES__teaser_pivot := $(QUEEN_PADME_TALES__teaser_dir)/index.xhtml

screenplay_targets: $(ST_WTLD_TEXT_IN_TREE) $(SCREENPLAY_XMLS) $(SCREENPLAY_HTMLS) $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_SOURCES_ON_POST_DEST) $(FICTION_TEXT_SOURCES_ON_POST_DEST) $(SELINA_MANDRAKE_ENG_SCREENPLAY_XML_SOURCE) $(SUMMERSCHOOL_AT_THE_NSA_ENG_SCREENPLAY_XML_SOURCE) screenplay_epub_dests

$(PRE_DEST_HTML_TUT): $(HTML_TUT_HEB_HTML)
	mkdir -p $(PRE_DEST_HTML_TUT_BASE)
	rsync -r $(HTML_TUT_HEB_DIR)/ $(PRE_DEST_HTML_TUT_BASE)

screenplay_targets: $(QUEEN_PADME_TALES__teaser_pivot)

$(QUEEN_PADME_TALES__teaser_pivot):
	mkdir -p $(QUEEN_PADME_TALES__teaser_dir)
	rsync -a lib/repos/Star-Wars-opening-crawl-from-1977-Remake/ $(QUEEN_PADME_TALES__teaser_dir)

$(HTML_TUT_HEB_DB): $(HTML_TUT_HEB_TT)
	cd $(HTML_TUT_BASE) && gmake docbook

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

$(PRE_DEST)/site-map/index.xhtml: $(ALL_SUBSECTS_DEPS)

MAIN_TOTAL_MIN_JS_DEST := $(POST_DEST)/js/main_all.js
EXPANDER_MIN_JS_DEST := $(POST_DEST)/js/jquery.expander.min.js
EXPANDER_JS_DEST := $(POST_DEST)/js/jquery.expander.js
EXPANDER_JS_SRC := lib/js/jquery-expander/jquery.expander.js
MULTI_YUI := ./bin/Run-YUI-Compressor

$(EXPANDER_MIN_JS_DEST): $(EXPANDER_JS_SRC)
	$(MULTI_YUI) -o $@ $<

# Must not be sorted!
MAIN_TOTAL_MIN_JS__SOURCES := \
	bower_components/jquery/dist/jquery.min.js \
	common/js/toggler.js \
	common/js/toggle_sect.js \
	bower_components/jqTree/tree.jquery.js \
	common/js/to-jqtree.js \
	common/js/to-jqtree-2.js \
	common/js/selfl.js \
	common/js/sub_menu.js \

$(MAIN_TOTAL_MIN_JS_DEST): $(MULTI_YUI) $(MAIN_TOTAL_MIN_JS__SOURCES)
	$(MULTI_YUI) -o $@ $(MAIN_TOTAL_MIN_JS__SOURCES)

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

FACTOIDS_RENDER_SCRIPT := $(LATEMP_ROOT_SOURCE_DIR)/lib/factoids/gen-html.pl
FACTOIDS_TIMESTAMP := lib/factoids/TIMESTAMP
FACTOIDS_GENERATED_FILES := lib/factoids/indiv-lists-xhtmls/buffy_facts--en-US.xhtml.reduced
FACTOIDS_GEN_CMD := $(PERL) $(FACTOIDS_RENDER_SCRIPT)

$(FACTOIDS_TIMESTAMP): $(FACTOIDS_RENDER_SCRIPT) lib/factoids/shlomif-factoids-lists.xml
	$(FACTOIDS_GEN_CMD)

all: $(FACTOIDS_TIMESTAMP)

# $(FACTOIDS_DOCS_DEST): $(FACTOIDS_GENERATED_FILES)

all: manifest_html

manifest_html: $(MANIFEST_HTML)

$(FACTOIDS_NAV_JSON):
	$(FACTOIDS_GEN_CMD)

LC_LECTURE_ARC_BASE := Lambda-Calculus.tar.gz
LC_LECTURE_ARC_DIR := $(PRE_DEST)/lecture
LC_LECTURE_ARC := $(LC_LECTURE_ARC_DIR)/$(LC_LECTURE_ARC_BASE)

all: $(LC_LECTURE_ARC)

$(LC_LECTURE_ARC): $(LC_PRES_DEST_HTMLS__PIVOT)
	(filelist() { find Lambda-Calculus/slides -type f -print | (LC_All=C sort) ; } ; cd $(LC_LECTURE_ARC_DIR) && touch -d 2019-12-05T08:53:00Z $$(filelist) && tar $(QUADPRES__TAR_OPTIONS) "--mode=go=rX,u+rw,a-s" -caf $(LC_LECTURE_ARC_BASE) $$(filelist))

OCT_2014_SGLAU_LET_DIR := $(SRC_SRC_DIR)/philosophy/SummerNSA/Letter-to-SGlau-2014-10
OCT_2014_SGLAU_LET_PDF := $(OCT_2014_SGLAU_LET_DIR)/letter-to-sglau.pdf
OCT_2014_SGLAU_LET_HTML := $(OCT_2014_SGLAU_LET_DIR)/letter-to-sglau.xhtml

all: $(OCT_2014_SGLAU_LET_PDF) $(OCT_2014_SGLAU_LET_HTML)

RINDOLF_IMAGES_POST_DEST := $(POST_DEST)/me/rindolf/images

RPG_DICE_SET_SRC := $(RINDOLF_IMAGES_POST_DEST)/rpg-dice-set--on-nuc.webp
RPG_DICE_SET_DEST := $(RINDOLF_IMAGES_POST_DEST)/rpg-dice-set--on-nuc--thumb.webp

MY_NAME_IS_RINDOLF_SRC := $(RINDOLF_IMAGES_POST_DEST)/my-name-is-rindolf.jpg
MY_NAME_IS_RINDOLF_DEST := $(RINDOLF_IMAGES_POST_DEST)/my-name-is-rindolf-200w.jpg

Shlomif_cutethulhu_SRC := common/images/shlomif-cutethulhu.webp
Shlomif_cutethulhu_DEST := $(POST_DEST)/images/shlomif-cutethulhu-small.webp
Evilphish_flipped_src := $(POST_DEST)/images/evilphish.png

$(Evilphish_flipped_dest): $(Evilphish_flipped_src)
	gm convert -flop $< $@

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

Linux1_webp_DEST := $(POST_DEST)/art/images/linux1.webp
$(Linux1_webp_DEST): $(SRC_SRC_DIR)/art/images/linux1.gif
	gm convert $< -define webp:lossless=true $@

all: $(Linux1_webp_DEST)

$(OCT_2014_SGLAU_LET_PDF): $(SRC_SRC_DIR)/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.odt
	export A="$$PWD" ; cd $(OCT_2014_SGLAU_LET_DIR) && oowriter --headless --convert-to pdf "$$A/$<"

$(OCT_2014_SGLAU_LET_HTML): $(SRC_SRC_DIR)/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.odt
	export A="$$PWD" ; cd $(OCT_2014_SGLAU_LET_DIR) && oowriter --headless --convert-to xhtml "$$A/$<"

$(MY_NAME_IS_RINDOLF_DEST): $(MY_NAME_IS_RINDOLF_SRC)
	gm convert -resize '200' $< $@

$(RPG_DICE_SET_DEST): $(RPG_DICE_SET_SRC)
	gm convert -resize '300x' $< $@

all: $(RPG_DICE_SET_DEST)

$(Shlomif_cutethulhu_DEST): $(Shlomif_cutethulhu_SRC)
	gm convert -resize '170x' $< $@

all: $(Shlomif_cutethulhu_DEST)

ENEMY_STYLE := $(PRE_DEST)/humour/TheEnemy/The-Enemy-English-v7/style.css

all: $(ENEMY_STYLE)

$(ENEMY_STYLE):
	mkdir -p "$$(dirname "$@")"
	touch $@

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

$(SRC_FORTUNES_ALL__HTML__POST): $(SRC_CLEAN_STAMP)

SRC_MODS_DIR := lib/assets/mods

MODS := $(shell cd $(SRC_MODS_DIR) && ls *.{s3m,xm,mod})

ZIP_MODS := $(addsuffix .zip,$(MODS))
XZ_MODS := $(addsuffix .xz,$(MODS))

POST_DEST_MODS_DIR := $(POST_DEST)/Iglu/shlomif/mods
dest_mods = $(addprefix $(POST_DEST_MODS_DIR)/,$(1))
POST_DEST_ZIP_MODS := $(call dest_mods,$(ZIP_MODS))
POST_DEST_XZ_MODS := $(call dest_mods,$(XZ_MODS))
POST_DEST_ALL_MODS := $(POST_DEST_ZIP_MODS) $(POST_DEST_XZ_MODS)

PROCESS_ALL_INCLUDES__NON_INPLACE := $(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/post-incs-v2.pl
PROC_INCLUDES_COMMON2 = APPLY_TEXTS=1 xargs $(PROCESS_ALL_INCLUDES__NON_INPLACE) --mode=minify --minifier-conf=bin/html-min-cli-config-file.conf --texts-dir=lib/ads --source-dir=$(1) --dest-dir=$(2) --
PROC_INCLUDES_COMMON := $(call PROC_INCLUDES_COMMON2,$(PRE_DEST),$(POST_DEST))
STRIP_src_dir_DEST := $(PERL) -lpe 's=\A(?:./)?$(PRE_DEST)/?=='
find_htmls = find $(1) -name '*.html' -o -name '*.xhtml'

WMLect_PATH := lecture/WebMetaLecture/slides/examples

$(SRC_CLEAN_STAMP): $(SRC_DOCS_DEST) $(PRES_TARGETS_ALL_FILES) $(SPORK_LECTURES_DEST_STARTS) $(MANIFEST_HTML) $(BK2HP_NEW_PNG) $(MATHJAX_DEST_README) $(POST_DEST_ZIP_MODS) $(POST_DEST_XZ_MODS) $(SCREENPLAY_XML__RAW_HTMLS__DESTS) $(FORTUNES_BUILT_TARGETS) $(FORTS_EPUB_DEST)
	$(call find_htmls,$(PRE_DEST)) | grep -vF -e philosophy/by-others/sscce -e WebMetaLecture/slides/examples -e homesteading/catb-heb -e $(SRC_SRC_DIR)/catb-heb.html | $(STRIP_src_dir_DEST) | $(PROC_INCLUDES_COMMON)
	rsync --exclude '*.html' --exclude '*.xhtml' -a $(PRE_DEST)/ $(POST_DEST)/
	find $(POST_DEST) -name '*.epub' -o -name '*.zip' | xargs -n 3 -P 8 $(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/normalize-zips.pl
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/gen-index-xhtmls-redirects.pl
	rsync -a $(PRE_DEST)/$(WMLect_PATH)/ $(POST_DEST)/$(WMLect_PATH)
	touch $@

FASTRENDER_DEPS := $(patsubst $(PRE_DEST)/%,$(SRC_SRC_DIR)/%.tt2,$(SRC_DOCS_DEST)) all_deps

FAQ_SECTS__DIR := $(POST_DEST)/meta/FAQ
FAQ_SECTS__PIVOT := $(FAQ_SECTS__DIR)/diet.xhtml
FAQ_SECTS__SRC := $(FAQ_SECTS__DIR)/index.xhtml
FAQ_SECTS__PROGRAM := lib/faq/split_into_sections.py

$(FAQ_SECTS__PIVOT): $(FAQ_SECTS__SRC) $(FAQ_SECTS__PROGRAM)
	python3 $(FAQ_SECTS__PROGRAM)
	(cd $(FAQ_SECTS__DIR) && ls *.xhtml) | $(call PROC_INCLUDES_COMMON2,$(FAQ_SECTS__DIR),$(FAQ_SECTS__DIR))

$(FAQ_SECTS__SRC): $(SRC_CLEAN_STAMP)

all: $(FAQ_SECTS__PIVOT)

fastrender: fastrender-tt2 $(SRC_FORTUNES_ALL__HTML)

fastrender-tt2: $(FASTRENDER_DEPS)
	@echo $(MAKE) fastrender-tt2
	perl bin/tt-render.pl

copy_images_target: $(SRC_IMAGES_DEST) $(SRC_COMMON_IMAGES_DEST)

SRC_jpgs__BASE := $(filter $(POST_DEST)/humour/bits/%.jpg,$(SRC_IMAGES_DEST))
SRC_jpgs__webps := $(SRC_jpgs__BASE:%.jpg=%.webp)
$(SRC_jpgs__webps): %.webp: %.jpg
	$(call simple_gm)

SRC_pngs__BASE := $(filter $(POST_DEST)/humour/bits/%.png,$(SRC_IMAGES_DEST))
SRC_pngs__BASE += $(POST_DEST_HTML_6_LOGO_PNG)
SRC_pngs__BASE += $(POST_DEST)/humour/images/14920899703_243677cbf4_o--cropped.png
SRC_pngs__BASE += $(POST_DEST)/humour/images/14920899703_243677cbf4_o--crop150w.png
SRC_pngs__BASE += $(POST_DEST)/humour/images/14920899703_243677cbf4_o--crop300w.png
SRC_pngs__BASE += $(POST_DEST)/images/shlomi-fish-in-a-red-ET-shirt--IMG_20201218_190912--200w.png
SRC_pngs__webps := $(SRC_pngs__BASE:%.png=%.webp)
$(SRC_pngs__webps): %.webp: %.png
	$(call simple_gm)

SRC_SVGS__BASE := $(filter %.svg,$(SRC_IMAGES_DEST))
SRC_SVGS__MIN := $(SRC_SVGS__BASE:%.svg=%.min.svg)
SRC_SVGS__svgz := $(SRC_SVGS__BASE:%.svg=%.svgz)

$(SRC_SVGS__MIN): %.min.svg: %.svg
	minify --svg-precision 5 -o $@ $<

$(SRC_SVGS__svgz): %.svgz: %.min.svg
	gzip --best -n < $< > $@

minified_assets: $(SRC_SVGS__MIN) $(SRC_SVGS__svgz) $(BK2HP_SVG_SRC) $(SRC_jpgs__webps) $(SRC_pngs__webps) $(MAIN_TOTAL_MIN_JS_DEST) $(EXPANDER_MIN_JS_DEST) $(EXPANDER_JS_DEST)

TEST_TARGETS := Tests/*.{py,t}

PRE_DEST_FORTUNES_many_files := $(PRE_DEST_FORTUNES)
POST_DEST_FORTUNES_many_files := $(POST_DEST_FORTUNES_SQLITE_DB)
POST_DEST_FIERY_Q_PNG := $(POST_DEST_HUMOUR)/Star-Trek/We-the-Living-Dead/images/fiery-Q.png
CATB_COPY := $(PRE_DEST)/catb-heb.xhtml
CATB_COPY_POST := $(POST_DEST)/catb-heb.xhtml

include lib/make/copies-generated-include.mak
include lib/make/docbook/screenplays-copy-operations.mak

screenplay_targets: $(SCREENPLAY_SOURCES_ON_POST_DEST__EXTRA_TARGETS)
docbook_targets: docbook_hhfg_images
docbook_targets: screenplay_targets

$(FICTION_DB5S): $(DOCBOOK5_XML_DIR)/%.xml: $(FICTION_XML_XML_DIR)/%.xml
	xslt="$(patsubst $(FICTION_XML_XML_DIR)/%.xml,$(FICTION_XML_DB5_XSLT_DIR)/%.xslt,$<)" ; \
	temp_db5="$(patsubst $(FICTION_XML_XML_DIR)/%.xml,$(FICTION_XML_TEMP_DB5_DIR)/%.xml,$<)" ; \
	if test -e "$$xslt" ; then \
		$(PERL) -MXML::Grammar::Fiction::App::ToDocBook -e 'run()' -- \
			-o "$$temp_db5" $< && \
		xsltproc --output "$@" "$$xslt" "$$temp_db5" ; \
	else \
		$(PERL) -MXML::Grammar::Fiction::App::ToDocBook -e 'run()' -- \
			-o $@ $< ; \
	fi
	$(PERL) -i -lape 's/\s+$$//' $@

$(PRE_DEST)/open-source/projects/XML-Grammar/Fiction/index.xhtml: \
	$(DOCBOOK5_RENDERED_DIR)/fiction-text-example-for-X-G-Fiction-demo.xhtml \
	$(FICTION_XML_TXT_DIR)/fiction-text-example-for-X-G-Fiction-demo.txt \
	$(SCREENPLAY_XML_RENDERED_HTML_DIR)/humanity-excerpt-for-X-G-Screenplay-demo.html \
	$(SCREENPLAY_XML_TXT_DIR)/humanity-excerpt-for-X-G-Screenplay-demo.txt \

$(DOCBOOK5_BASE_DIR)/xml/my-real-person-fiction.xml: $(SUB_REPOS_BASE_DIR)/my-real-person-fan-fiction/README.asciidoc
	$(call ASCIIDOCTOR_TO_DOCBOOK5)

$(DOCBOOK5_BASE_DIR)/xml/who-gets-the-final-say.xml: $(LATEMP_ROOT_SOURCE_DIR)/lib/asciidocs/who-gets-the-final-say.asciidoc
	$(call ASCIIDOCTOR_TO_DOCBOOK5)

$(DOCBOOK5_BASE_DIR)/xml/why-openly-bipolar-people-should-not-be-medicated.xml: $(SUB_REPOS_BASE_DIR)/why-openly-bipolar-people-should-not-be-medicated/README.asciidoc
	$(call ASCIIDOCTOR_TO_DOCBOOK5)

$(DOCBOOK5_BASE_DIR)/xml/Spark-Pre-Birth-of-a-Modern-Lisp.xml: $(SRC_SRC_DIR)/open-source/projects/Spark/mission/Spark-Pre-Birth-of-a-Modern-Lisp.txt
	$(call ASCIIDOCTOR_TO_DOCBOOK5)

JSON_RES_BASE := me/resumes/Shlomi-Fish-Resume.jsonresume

JSON_RES_DEST := $(POST_DEST)/$(JSON_RES_BASE).json

$(JSON_RES_DEST): $(SRC_SRC_DIR)/$(JSON_RES_BASE).yaml
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/my-yaml-2-canonical-json.pl -i $< -o $@

non_latemp_targets: $(JSON_RES_DEST) $(SRC_SRC_FORTUNE_SHOW_PY)

$(MANIFEST_HTML): $(LATEMP_ROOT_SOURCE_DIR)/bin/gen-manifest.pl $(ENEMY_STYLE) $(ALL_HTACCESSES) $(SPORK_LECTURES_DEST_STARTS)
	$(PERL) $<

all_deps: $(CATB_COPY) $(Evilphish_flipped_dest)

all: $(CATB_COPY_POST)

copy_fortunes: $(PRE_DEST_FORTUNES_many_files) $(POST_DEST_FORTUNES_many_files)

mod_files: $(POST_DEST_ALL_MODS)

$(POST_DEST_XZ_MODS): $(POST_DEST_MODS_DIR)/%.xz: $(SRC_MODS_DIR)/%
	xz -9 --extreme < $< > $@

$(POST_DEST_ZIP_MODS): $(POST_DEST_MODS_DIR)/%.zip: $(SRC_MODS_DIR)/%
	TZ=UTC zip -joqX9 "$@" "$<"

all_deps: $(SRC_IMAGES_DEST)

TEST_ENV = PYTHONPATH="$${PYTHONPATH}:$(LATEMP_ABS_ROOT_SOURCE_DIR)/Tests/lib"

.PHONY: bulk-make-dirs fortunes-compile-xmls install_docbook_css_dirs install_docbook_individual_xhtmls install_docbook_xmls make-dirs mod_files presentations_targets
