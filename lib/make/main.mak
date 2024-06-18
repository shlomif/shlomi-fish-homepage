# Whether this is the development environment
DEV = 0

DEV_WML_FLAGS :=
T2_POST_DEST = dest/post-incs/t2

ifeq ($(DEV),1)
	DEV_WML_FLAGS := -DLATEMP_IS_DEV_ENV=1
endif

ALL_DEST_BASE = dest/pre-incs

MATHJAX_SOURCE_README = lib/js/MathJax/README.md

all: all_deps latemp_targets non_latemp_targets

all_deps: sects_cache docbook_targets fortunes-target copy_fortunes

non_latemp_targets: art_slogans_targets css_targets generate_nav_data_as_json htaccesses_target graham_func_pres_targets hhgg_convert lc_pres_targets mathjax_dest min_svgs minified_javascripts mod_files mojo_pres plaintext_scripts_with_offending_extensions printable_resumes__html presentations_targets site_source_install svg_nav_images

include lib/make/shlomif_common.mak
include lib/make/include.mak

BK2HP_SVG_BASE := images/bk2hp-v2.svg
T2_IMAGES := $(filter-out $(BK2HP_SVG_BASE),$(T2_IMAGES)) $(BK2HP_SVG_BASE)

include lib/make/rules.mak

BK2HP_SVG_SRC := $(T2_SRC_DIR)/$(BK2HP_SVG_BASE)

T2_POST_DIRS_DEST = $(addprefix $(T2_POST_DEST)/,$(T2_DIRS))
T2_TARGETS += $(T2_POST_DIRS_DEST)

LATEMP_WML_FLAGS += $(DEV_WML_FLAGS)
WML_FLAGS += --passoption=2,-X3330 --passoption=2,-I../lib/ \
	--passoption=3,-I../lib/ \
	-I../lib/ $(LATEMP_WML_FLAGS) \
	-p1-3,5,7,8 \
	-DROOT~. -DLATEMP_THEME=sf.org1 \
	-I $${HOME}/apps/wml

NAV_DATA_DEP = lib/MyNavData.pm
NAV_DATA_AS_JSON_BIN = bin/nav-data-as-json

SCREENPLAY_COMMON_INC_DIR = $(PWD)/lib/screenplay-xml/from-vcs/screenplays-common

DOCS_COMMON_DEPS = lib/template.wml $(NAV_DATA_DEP)

FORTUNES_DIR = humour/fortunes
T2_FORTUNES_DIR = $(T2_SRC_DIR)/$(FORTUNES_DIR)
SRC_FORTUNES_DIR = src/$(FORTUNES_DIR)

include $(T2_FORTUNES_DIR)/fortunes-list.mak

T2_ALL_DIRS_DEST = $(T2_DIRS_DEST) $(T2_COMMON_DIRS_DEST)

PROCESS_ALL_INCLUDES__NON_INPLACE = $(PERL) bin/post-incs-v2.pl

WML_RENDER = LATEMP_WML_FLAGS="$(LATEMP_WML_FLAGS)" $1 bin/render
T2_INCLUDE_WML_RENDER = $(call WML_RENDER,UNCOND=1) "${@:$(T2_DEST)/%=%}"

make-dirs: $(T2_ALL_DIRS_DEST)

MAN_HTML = $(T2_DEST)/MANIFEST.html
GEN_SECT_NAV_MENUS = ./bin/gen-sect-nav-menus.pl
SITE_SOURCE_INSTALL_TARGET = $(T2_DEST)/meta/site-source/INSTALL
T2_DEST_FORTUNES_DIR = $(T2_DEST)/$(FORTUNES_DIR)
T2_POST_DEST_FORTUNES_DIR = $(T2_POST_DEST)/$(FORTUNES_DIR)
FORTUNES_TARGET =  $(T2_DEST_FORTUNES_DIR)/index.xhtml

FORTUNES_ALL_IN_ONE__BASE = all-in-one.html
FORTUNES_ALL_IN_ONE__TEMP__BASE = all-in-one.uncompressed.html
T2_FORTUNES_ALL_WML = $(SRC_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__TEMP__BASE).tt2
T2_FORTUNES_ALL__HTML = $(T2_DEST_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__BASE)
T2_FORTUNES_ALL__HTML__POST = $(T2_POST_DEST_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__TEMP__BASE)
T2_FORTUNES_ALL__TEMP__HTML = $(T2_DEST_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__TEMP__BASE)

SECTION_MENU_DEPS = lib/Shlomif/Homepage/SectionMenu.pm
PHILOSOPHY_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Essays.pm
LECTURES_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Lectures.pm
SOFTWARE_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Software.pm
HUMOUR_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Humour.pm
META_SUBSECT_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Meta.pm
PUZZLES_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Puzzles.pm
ART_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Art.pm

ALL_SUBSECTS_DEPS = $(PHILOSOPHY_DEPS) $(LECTURES_DEPS) $(SOFTWARE_DEPS) $(HUMOUR_DEPS) $(META_SUBSECT_DEPS) $(PUZZLES_DEPS) $(ART_DEPS)

FACTOIDS_NAV_JSON = lib/Shlomif/factoids-nav.json

T2_CACHE_ALL_STAMP = lib/cache/STAMP.sects-includes
T2_CLEAN_STAMP = lib/cache/STAMP.post-dest

T2_CACHE_PREF = lib/cache/combined/t2

GEN_CACHE_CMD = $(PERL) $(GEN_SECT_NAV_MENUS) $$(cat lib/make/tt2.txt) $(T2_DOCS) $(FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__TEMP__BASE) $(FORTUNES_DIR)/index.xhtml $(patsubst %,$(FORTUNES_DIR)/%.html,$(FORTUNES_FILES_BASE) $(FORTUNES_ALL_IN_ONE__TEMP__BASE))

$(T2_CACHE_ALL_STAMP): $(GEN_SECT_NAV_MENUS) $(FACTOIDS_NAV_JSON) $(ALL_SUBSECTS_DEPS)
	@echo "Generating sects_cache"
	@$(GEN_CACHE_CMD)
	touch $@

sects_cache: make-dirs $(T2_CACHE_ALL_STAMP)

site_source_install: $(SITE_SOURCE_INSTALL_TARGET)

$(T2_POST_DIRS_DEST): %:
	mkdir -p $@
	touch $@

make-dirs: $(T2_POST_DIRS_DEST)

make-dirs: $(DOCBOOK5_ALL_IN_ONE_XHTMLS__DIRS)

$(DOCBOOK5_ALL_IN_ONE_XHTMLS__DIRS):
	mkdir -p $@

bulk-make-dirs:
	@mkdir -p $(T2_ALL_DIRS_DEST) $(T2_POST_DIRS_DEST) $(DOCBOOK5_ALL_IN_ONE_XHTMLS__DIRS)

DEST_HUMOUR := $(T2_DEST)/humour
DEST_POPE := $(DEST_HUMOUR)/Pope
all: $(DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.xml
all: $(DEST_POPE)/The-Pope-Died-on-Sunday-english.xml

T2_DEST_SHOW_CGI = $(T2_DEST_FORTUNES_DIR)/show.cgi
T2_POST_DEST_SHOW_CGI = $(T2_POST_DEST_FORTUNES_DIR)/show.cgi
T2_SRC_FORTUNE_SHOW_SCRIPT = $(T2_SRC_DIR)/$(FORTUNES_DIR)/show.cgi
T2_SRC_FORTUNE_SHOW_PY = $(T2_SRC_DIR)/$(FORTUNES_DIR)/fortunes_show.py
T2_SRC_BOTTLE = $(T2_SRC_DIR)/$(FORTUNES_DIR)/bottle.py
T2_DEST_FORTUNE_SHOW_SCRIPT_TXT = $(T2_DEST_FORTUNES_DIR)/show-cgi.txt
T2_DEST_FORTUNE_BOTTLE = $(T2_DEST_FORTUNES_DIR)/bottle.py

htacc = $(addsuffix /.htaccess,$(1))
T2_FORTUNES_DIR_HTACCESS = $(call htacc,$(T2_DEST_FORTUNES_DIR))

ALL_HTACCESSES = $(call htacc,$(T2_DEST_FORTUNES_DIR) $(addprefix $(T2_DEST)/,lecture/PostgreSQL-Lecture))

htaccesses_target: $(ALL_HTACCESSES)

$(T2_FORTUNES_DIR)/my_htaccess.conf: $(T2_FORTUNES_DIR)/gen-htaccess.pl
	(cd $(T2_FORTUNES_DIR) && gmake)

$(T2_FORTUNES_ALL_WML): bin/gen-forts-all-in-one-page.pl $(FORTUNES_LIST_PM)
	$(PERL) -Ilib $< $@

T2_DEST_FORTUNES := $(patsubst $(T2_FORTUNES_DIR)/%,$(T2_DEST_FORTUNES_DIR)/%,$(wildcard $(T2_FORTUNES_DIR)/fortunes-shlomif-*.tar.gz))

chmod_copy = $(call COPY) ; chmod +x $@

$(T2_DEST_SHOW_CGI): $(T2_SRC_FORTUNE_SHOW_SCRIPT)
	$(call chmod_copy)

$(T2_SRC_FORTUNE_SHOW_PY): $(T2_SRC_FORTUNE_SHOW_SCRIPT)
	$(call chmod_copy)

$(T2_DEST_FORTUNE_SHOW_SCRIPT_TXT): $(T2_SRC_FORTUNE_SHOW_SCRIPT)
	$(call chmod_copy)

RSYNC_EXCLUDES := --exclude='**/js/MathJax/**'

ifeq ($(UPLOAD_MATHJAX),1)
	RSYNC_EXCLUDES :=
endif

UPLOAD = (cd $(T2_POST_DEST) && $(RSYNC) $(RSYNC_EXCLUDES) -a . $1 )

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

upload_all: upload upload_var upload_local upload_beta

upload_hostgator: upload_deps
	$(call UPLOAD,'hostgator:public_html/')

$(T2_DEST)/open-source/projects/Spark/mission/index.xhtml : lib/docbook/5/rendered/Spark-Pre-Birth-of-a-Modern-Lisp.xhtml
$(T2_DEST)/philosophy/Index/index.xhtml : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl

T2_DOCS_SRC = $(patsubst $(T2_DEST)/%,$(T2_SRC_DIR)/%.wml,$(T2_DOCS_DEST))

t2_filt_file = $(filter $(T2_DEST)/$1,$(T2_DOCS_DEST))
t2_filt = $(filter $(T2_DEST)/$1/%,$(T2_DOCS_DEST))
t2_src_filt = $(filter $(T2_SRC_DIR)/$1/%,$(T2_DOCS_SRC))

T2_PHILOSOPHY_DOCS = \
	$(call t2_filt,philosophy) \
	$(call t2_filt,prog-evolution) \
	$(call t2_filt,DeCSS)

$(T2_PHILOSOPHY_DOCS): %: $(PHILOSOPHY_DEPS)

T2_LECTURES_DOCS_SRC = $(call t2_src_filt,lecture/)

$(T2_LECTURES_DOCS_SRC): $(T2_SRC_DIR)/lecture/%.wml: $(LECTURES_DEPS)
	touch $@

T2_SOFTWARE_DOCS_SRC = $(call t2_src_filt,open-source) \
					   $(call t2_src_filt,jmikmod) \
					   $(call t2_src_filt,grad-fu) \
					   $(call t2_src_filt,no-ie) \
					   $(call t2_src_filt,rindolf) \
					   $(call t2_src_filt,rwlock)

$(T2_SOFTWARE_DOCS_SRC): $(T2_SRC_DIR)/%.wml: $(SOFTWARE_DEPS)
	touch $@

#### Humour thing

T2_HUMOUR_DOCS_DEST = \
	$(call t2_filt,humour) \
	$(call t2_filt_file,humour.html) \
	$(call t2_filt_file,humour-heb.html) \
	$(call t2_filt_file,wysiwyt.html) \
	$(call t2_filt_file,wonderous.html)

$(T2_HUMOUR_DOCS_DEST): $(HUMOUR_DEPS)

T2_ART_DOCS_DEST = $(call t2_filt,art)

$(T2_ART_DOCS_DEST): $(ART_DEPS)

T2_PUZZLES_DOCS_SRC = $(call t2_src_filt,puzzles) $(call t2_src_filt,MathVentures) $(filter $(T2_SRC_DIR)/toggle.html.wml,$(T2_DOCS_SRC))

$(T2_PUZZLES_DOCS_SRC): $(T2_SRC_DIR)/%.wml: $(PUZZLES_DEPS)
	touch $@

T2_META_DOCS_DEST = $(call t2_filt,meta)

$(T2_META_DOCS_DEST): $(META_SUBSECT_DEPS)

$(T2_HUMOUR_DOCS_DEST): $(HUMOUR_DEPS)

rss:
	$(PERL) ./bin/fetch-shlomif_hsite-feed.pl
	touch $(SRC_SRC_DIR)/index.xhtml.tt2 $(SRC_SRC_DIR)/old-news.html.tt2

PROD_SYND_MUSIC_DIR = lib/prod-synd/music
PROD_SYND_MUSIC_INC = $(PROD_SYND_MUSIC_DIR)/include-me.html

PROD_SYND_NON_FICTION_BOOKS_DIR = lib/prod-synd/non-fiction-books
PROD_SYND_NON_FICTION_BOOKS_INC = $(PROD_SYND_NON_FICTION_BOOKS_DIR)/include-me.html

PROD_SYND_FILMS_DIR = lib/prod-synd/films
PROD_SYND_FILMS_INC = $(PROD_SYND_FILMS_DIR)/include-me.html

$(T2_DEST)/art/recommendations/music/index.xhtml: $(PROD_SYND_MUSIC_INC)

all_deps: $(PROD_SYND_MUSIC_INC)

GPERL = $(PERL) -Ilib
GPERL_DEPS = lib/Shlomif/Homepage/Amazon/Obj.pm

$(PROD_SYND_MUSIC_INC) : $(PROD_SYND_MUSIC_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/art/recommendations/music/shlomi-fish-music-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

$(T2_DEST)/philosophy/books-recommends/index.xhtml : $(PROD_SYND_NON_FICTION_BOOKS_INC)

all_deps : $(PROD_SYND_NON_FICTION_BOOKS_INC)

$(PROD_SYND_NON_FICTION_BOOKS_INC) : $(PROD_SYND_NON_FICTION_BOOKS_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/philosophy/books-recommends/shlomi-fish-non-fiction-books-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

$(DEST_HUMOUR)/recommendations/films/index.xhtml: $(PROD_SYND_FILMS_INC)

all_deps: $(PROD_SYND_FILMS_INC)

$(PROD_SYND_FILMS_INC) : $(PROD_SYND_FILMS_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/humour/recommendations/films/shlomi-fish-films-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

SCREENPLAY_DOCS_ADDITIONS = \
	ae-interview \
	Emma-Watson-applying-for-a-software-dev-job \
	Emma-Watson-visit-to-Israel-and-Gaza \
	hitchhikers-guide-to-star-trek-tng-hand-tweaked \
	humanity-excerpt-for-X-G-Screenplay-demo \
	Mighty-Boosh--Ape-of-Death--Scenes \
	sussman-interview

SCREENPLAY_DOCS = $(SCREENPLAY_DOCS_ADDITIONS) $(SCREENPLAY_DOCS_FROM_GEN)

FICTION_DOCS_ADDITIONS = \
	fiction-text-example-for-X-G-Fiction-demo \
	The-Enemy-Hebrew-rev6 \
	The-Enemy-Hebrew-v7

include lib/make/docbook/sf-fictions-list.mak

FICTION_DOCS = $(FICTION_DOCS_ADDITIONS) $(FICTION_DOCS_FROM_GEN)

SCREENPLAY_XML_BASE_DIR = lib/screenplay-xml
SCREENPLAY_XML_EPUB_DIR = $(SCREENPLAY_XML_BASE_DIR)/epub
SCREENPLAY_XML_XML_DIR = $(SCREENPLAY_XML_BASE_DIR)/xml
SCREENPLAY_XML_TXT_DIR = $(SCREENPLAY_XML_BASE_DIR)/txt
SCREENPLAY_XML_HTML_DIR = $(SCREENPLAY_XML_BASE_DIR)/html
SCREENPLAY_XML_FOR_OOO_XHTML_DIR = $(SCREENPLAY_XML_BASE_DIR)/for-ooo-xhtml
SCREENPLAY_XML_RENDERED_HTML_DIR = $(SCREENPLAY_XML_BASE_DIR)/rendered-html

FICTION_XML_BASE_DIR = lib/fiction-xml
FICTION_XML_XML_DIR = $(FICTION_XML_BASE_DIR)/xml
FICTION_XML_TXT_DIR = $(FICTION_XML_BASE_DIR)/txt
FICTION_XML_DB5_XSLT_DIR = $(FICTION_XML_BASE_DIR)/docbook5-post-proc
FICTION_XML_TEMP_DB5_DIR = $(FICTION_XML_BASE_DIR)/intermediate-docbook5-results

SCREENPLAY_XMLS = $(patsubst %,$(SCREENPLAY_XML_XML_DIR)/%.xml,$(SCREENPLAY_DOCS))
FICTION_XMLS = $(patsubst %,$(FICTION_XML_XML_DIR)/%.xml,$(FICTION_DOCS))

all: splay

include lib/make/docbook/sf-homepage-quadpres-generated.mak
include lib/make/docbook/sf-screenplays.mak

screenplay_docs = $(patsubst %,$(1)/%.$(2),$(SCREENPLAY_DOCS))

SCREENPLAY_RENDERED_HTMLS = $(call screenplay_docs,$(SCREENPLAY_XML_RENDERED_HTML_DIR),html)
SCREENPLAY_XML_HTMLS = $(call screenplay_docs,$(SCREENPLAY_XML_HTML_DIR),html)
SCREENPLAY_XML_EPUBS = $(patsubst %,$(SCREENPLAY_XML_EPUB_DIR)/%.epub,$(SCREENPLAY_DOCS_FROM_GEN))
SCREENPLAY_XML_FOR_OOO_XHTMLS = $(call screenplay_docs,$(SCREENPLAY_XML_FOR_OOO_XHTML_DIR),xhtml)

splay: $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_XML_HTMLS) $(SCREENPLAY_XML_EPUBS)

$(SCREENPLAY_XML_HTML_DIR)/%.html: $(SCREENPLAY_XML_XML_DIR)/%.xml
	$(PERL) -MXML::Grammar::Screenplay::App::ToHTML -e 'run()' -- \
	-o $@ $<
	$(PERL) -lpi -e 's/[ \t]+\z//' $@

$(SCREENPLAY_XML_RENDERED_HTML_DIR)/%.html: $(SCREENPLAY_XML_HTML_DIR)/%.html
	./bin/extract-screenplay-xml-html.pl -o $@ $<

$(SCREENPLAY_XML_FOR_OOO_XHTML_DIR)/%.xhtml: $(SCREENPLAY_XML_HTML_DIR)/%.html
	< $< $(PERL) -lne 'print unless m{\A<\?xml}' > $@

$(SCREENPLAY_XML_XML_DIR)/%.xml: $(SCREENPLAY_XML_TXT_DIR)/%.txt
	$(PERL) -MXML::Grammar::Screenplay::App::FromProto -e 'run()' -- \
	-o $@ $<
	$(PERL) -lpi -e 's/[ \t]+\z//' $@

DEST_HUMOUR_SELINA := $(DEST_HUMOUR)/Selina-Mandrake
DEST_INTERVIEWS := $(T2_DEST)/open-source/interviews

DEST_SPLAY_HHGG_STTNG := $(DEST_HUMOUR)/by-others/hitchhiker-guide-to-star-trek-tng-hand-tweaked.txt

SCREENPLAY_SOURCES_ON_DEST = $(DEST_INTERVIEWS)/ae-interview.txt $(DEST_INTERVIEWS)/sussman-interview.txt $(DEST_SPLAY_HHGG_STTNG)

HHFG_DIR = $(DEST_HUMOUR)/human-hacking
HHFG_HEB_V2_TXT = human-hacking-field-guide-hebrew-v2.txt
HHFG_HEB_V2_DEST = $(HHFG_DIR)/$(HHFG_HEB_V2_TXT)
HHFG_HEB_V2_XSLT_DEST = $(HHFG_DIR)/human-hacking-field-guide-hebrew-v2.db-postproc.xslt

FICTION_TEXT_SOURCES_ON_DEST = $(DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.txt $(HHFG_HEB_V2_DEST) $(HHFG_HEB_V2_XSLT_DEST) $(DEST_POPE)/The-Pope-Died-on-Sunday-english.txt

$(FICTION_XMLS): $(FICTION_XML_XML_DIR)/%.xml: $(FICTION_XML_TXT_DIR)/%.txt
	$(PERL) -MXML::Grammar::Fiction::App::FromProto -e 'run()' -- \
	-o $@ $<
	$(PERL) -i -lape 's/\s+$$//' $@

HHGG_CONVERT_SCRIPT_FN = convert-hitchhiker-guide-to-st-tng-to-screenplay-xml.pl
HHGG_CONVERT_SCRIPT_SRC = bin/processors/$(HHGG_CONVERT_SCRIPT_FN)
HHGG_CONVERT_SCRIPT_DEST = $(DEST_HUMOUR)/by-others/$(HHGG_CONVERT_SCRIPT_FN).txt

hhgg_convert: $(HHGG_CONVERT_SCRIPT_DEST)

FRON_IMAGE_BASE = fron-demon-illustration-small-indexed.png
SELINA_MANDRAKE_ENG_FRON_IMAGE__SOURCE = $(SELINA_MANDRAKE__VCS_DIR)/graphics/$(FRON_IMAGE_BASE)
SELINA_MANDRAKE_ENG_FRON_IMAGE__DEST = $(DEST_HUMOUR_SELINA)/images/$(FRON_IMAGE_BASE)

QOHELETH_IMAGES__BASE = sigourney-weaver--resized.jpg summer-glau--two-guns--400w.jpg Friends-S02E04--Nothing-Sexier.svg.jpg If-You-Wanna-Be-Sad.svg.jpg

QOHELETH_IMAGES__SOURCE_PREFIX = $(SO_WHO_THE_HELL_IS_QOHELETH__VCS_DIR)/graphics
QOHELETH_IMAGES__DEST_PREFIX = $(DEST_HUMOUR)/So-Who-The-Hell-Is-Qoheleth/images

QOHELETH_IMAGES__SOURCE = $(addprefix $(QOHELETH_IMAGES__SOURCE_PREFIX)/,$(QOHELETH_IMAGES__BASE))
QOHELETH_IMAGES__DEST = $(addprefix $(QOHELETH_IMAGES__DEST_PREFIX)/,$(QOHELETH_IMAGES__BASE))

TERM_LIBERATION_IMAGES__BASE = emma-watson-wandless.svg.webp
TERM_LIBERATION_IMAGES__SOURCE_PREFIX = $(TERMINATOR_LIBERATION__VCS_DIR)/graphics
TERM_LIBERATION_IMAGES__DEST_PREFIX = $(DEST_HUMOUR)/Terminator/Liberation/images

TERM_LIBERATION_IMAGES__SOURCE = $(addprefix $(TERM_LIBERATION_IMAGES__SOURCE_PREFIX)/,$(TERM_LIBERATION_IMAGES__BASE))
TERM_LIBERATION_IMAGES__DEST = $(addprefix $(TERM_LIBERATION_IMAGES__DEST_PREFIX)/,$(TERM_LIBERATION_IMAGES__BASE))

$(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng.txt : $(HHGG_CONVERT_SCRIPT_SRC) $(T2_SRC_DIR)/humour/by-others/hitchhiker-guide-to-star-trek-tng.txt
	$(PERL) $<

screenplay_epub_dests: $(SCREENPLAY_XML__EPUBS_DESTS)

# Rebuild the embedded docbook4 pages in the $(T2_DEST) after they are
# modified.

PUT_CARDS_2013_XHTML = lib/pages/t2/philosophy/putting-all-cards-on-the-table.xhtml
PUT_CARDS_2013_DEST = $(T2_DEST)/philosophy/philosophy/put-cards-2013.xhtml

PUT_CARDS_2013_XHTML_STRIPPED = $(PUT_CARDS_2013_XHTML).processed-stripped

STRIP_HTML_BIN = bin/processors/strip-html-overhead.pl
strip_html = $(PERL) $(STRIP_HTML_BIN) < $< > $@

$(PUT_CARDS_2013_XHTML_STRIPPED): $(PUT_CARDS_2013_XHTML) $(STRIP_HTML_BIN)
	$(call strip_html)

HOW_TO_GET_HELP_2013_XHTML = lib/pages/t2/philosophy/how-to-get-help-online.xhtml
HOW_TO_GET_HELP_2013_XHTML_STRIPPED = $(HOW_TO_GET_HELP_2013_XHTML).processed-stripped

$(HOW_TO_GET_HELP_2013_XHTML_STRIPPED): $(HOW_TO_GET_HELP_2013_XHTML) $(STRIP_HTML_BIN)
	$(call strip_html)

$(T2_DEST)/philosophy/computers/how-to-get-help-online/2013.html: $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)

all_deps: $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)
all_deps: $(T2_FORTUNES_ALL_WML)

all: $(PUT_CARDS_2013_DEST) $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)

$(T2_DEST)/philosophy/philosophy/putting-all-cards-on-the-table-2013/index.xhtml : $(PUT_CARDS_2013_XHTML_STRIPPED)

# Rebuild the pages containing the links to $(T2_SRC_DIR)/humour/stories upon changing
# the lib/stories.

$(DEST_HUMOUR)/index.xhtml $(DEST_HUMOUR)/stories/index.xhtml $(DEST_HUMOUR)/stories/Star-Trek/index.xhtml $(DEST_HUMOUR)/stories/Star-Trek/We-the-Living-Dead/index.xhtml $(DEST_HUMOUR)/TheEnemy/index.xhtml: lib/stories/stories-list.tt2

$(DEST_HUMOUR)/humanity/index.xhtml $(DEST_HUMOUR)/humanity/ongoing-text.html $(DEST_HUMOUR)/humanity/buy-the-fish-in-hebrew.html $(DEST_HUMOUR)/humanity/ongoing-text-hebrew.html : lib/stories/blurbs.tt2

tidy: all
	$(PERL) bin/run-tidy.pl

.PHONY: install_docbook4_pdfs install_docbook_xmls install_docbook4_rtfs install_docbook_individual_xhtmls install_docbook_css_dirs make-dirs bulk-make-dirs presentations_targets

# This copies all the .pdf's at once - not ideal, but still
# working.

$(DOCBOOK4_INSTALLED_CSS_DIRS) : lib/sgml/docbook-css/docbook-css-0.4/
	mkdir -p $@
	rsync -r $< $@

FORTUNES_XHTMLS_DIR = lib/fortunes/xhtmls

FORTUNES_LIST_PM = lib/Shlomif/Homepage/FortuneCollections.pm
FORTUNES_LIST__DEPS = $(FORTUNES_LIST_PM) lib/Shlomif/fortunes-meta-data.yml

FORTUNES_XMLS_BASE = $(addsuffix .xml,$(FORTUNES_FILES_BASE))
FORTUNES_XMLS_SRC = $(addprefix $(T2_FORTUNES_DIR)/,$(FORTUNES_XMLS_BASE))
FORTUNES_XHTMLS = $(patsubst $(T2_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_XHTMLS_TOCS = $(patsubst $(T2_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.toc-xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_SOURCE_WMLS = $(patsubst %,$(SRC_FORTUNES_DIR)/%.html.tt2,$(FORTUNES_FILES_BASE))
FORTUNES_DEST_HTMLS = $(patsubst $(SRC_FORTUNES_DIR)/%.html.tt2,$(T2_DEST_FORTUNES_DIR)/%.html,$(FORTUNES_SOURCE_WMLS))
FORTUNES_XHTMLS__COMPRESSED = $(patsubst %.xhtml,%.compressed.xhtml,$(FORTUNES_XHTMLS))
FORTUNES_XHTMLS__FOR_INPUT_PORTIONS = $(patsubst %.xhtml,%.xhtml-for-input,$(FORTUNES_XHTMLS))
FORTUNES_WMLS_HTMLS = $(patsubst %,$(T2_DEST_FORTUNES_DIR)/%.html,$(FORTUNES_FILES_BASE))
FORTUNES_TEXTS = $(patsubst %.xml,%,$(FORTUNES_XMLS_SRC))
FORTUNES_ATOM_FEED = $(T2_FORTUNES_DIR)/fortunes-shlomif-all.atom
FORTUNES_RSS_FEED = $(T2_FORTUNES_DIR)/fortunes-shlomif-all.rss
FORTUNES_SQLITE_BASENAME := fortunes-shlomif-lookup.sqlite3
T2_DEST_FORTUNES_SQLITE_DB = $(T2_DEST_FORTUNES_DIR)/$(FORTUNES_SQLITE_BASENAME)
FORTUNES_SQLITE_DB = $(T2_FORTUNES_DIR)/$(FORTUNES_SQLITE_BASENAME)
T2_DEST_HTMLS_FORTUNES = $(patsubst %,$(T2_DEST_FORTUNES_DIR)/%.html,$(FORTUNES_FILES_BASE))

fortunes-compile-xmls: $(FORTUNES_SOURCE_WMLS) $(FORTUNES_XHTMLS) $(FORTUNES_XHTMLS__COMPRESSED) $(FORTUNES_TEXTS) $(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED) $(FORTUNES_SQLITE_DB)

include lib/make/factoids.mak

# The touch is to make sure we compile the .html.wml again.

FORTUNES_CONVERT_TO_XHTML_SCRIPT = $(T2_FORTUNES_DIR)/convert-to-xhtml.pl
FORTUNES_PREPARE_FOR_INPUT_SCRIPT = $(T2_FORTUNES_DIR)/prepare-xhtml-for-input.pl

$(FORTUNES_SOURCE_WMLS): $(FORTUNES_LIST__DEPS)
	$(PERL) -Ilib -MShlomif::Homepage::FortuneCollections -e 'Shlomif::Homepage::FortuneCollections->print_all_fortunes_html_wmls()'

$(FORTUNES_XHTMLS__FOR_INPUT_PORTIONS): %.xhtml-for-input: %.compressed.xhtml $(FORTUNES_PREPARE_FOR_INPUT_SCRIPT)
	$(PERL) $(FORTUNES_PREPARE_FOR_INPUT_SCRIPT) $< $@

$(FORTUNES_XHTMLS): $(FORTUNES_XHTMLS_DIR)/%.xhtml : $(T2_FORTUNES_DIR)/%.xml $(FORTUNES_CONVERT_TO_XHTML_SCRIPT)
	$(PERL) $(FORTUNES_CONVERT_TO_XHTML_SCRIPT) $< $@

FORTUNES_XML_TO_XHTML_TOC_XSLT = lib/fortunes/fortune-xml-to-xhtml-toc.xslt

$(FORTUNES_XHTMLS_TOCS): $(FORTUNES_XHTMLS_DIR)/%.toc-xhtml : $(T2_FORTUNES_DIR)/%.xml $(FORTUNES_XML_TO_XHTML_TOC_XSLT)
	xsltproc $(FORTUNES_XML_TO_XHTML_TOC_XSLT) $< | \
	$(PERL) -0777 -lapE 's#\A.*?<ul[^>]*?>#<ul>#ms; s#^[ \t]+##gms; s#[ \t]+$$##gms' - > \
	$@

$(FORTUNES_WMLS_HTMLS): $(T2_DEST_FORTUNES_DIR)/%.html: $(FORTUNES_XHTMLS_DIR)/%.xhtml-for-input

FORTUNES_TIDY = tidy -asxhtml -utf8 -quiet

$(FORTUNES_XHTMLS__COMPRESSED): %.compressed.xhtml: %.xhtml
	$(FORTUNES_TIDY) --show-warnings no -o $@ $< || true

$(FORTUNES_TEXTS): $(T2_FORTUNES_DIR)/%: $(T2_FORTUNES_DIR)/%.xml
	bash $(T2_FORTUNES_DIR)/run-validator.bash $< && \
	$(PERL) $(T2_FORTUNES_DIR)/convert-to-plaintext.pl $< $@

$(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED): $(T2_FORTUNES_DIR)/generate-web-feeds.pl $(FORTUNES_XMLS_SRC)
	$(PERL) $< --atom $(FORTUNES_ATOM_FEED) --rss $(FORTUNES_RSS_FEED) --dir $(T2_FORTUNES_DIR)

$(FORTUNES_SQLITE_DB): $(T2_FORTUNES_DIR)/populate-sqlite-database.pl $(FORTUNES_XHTMLS__COMPRESSED) $(FORTUNES_LIST__DEPS)
	$(PERL) -Ilib $<

$(FORTUNES_TARGET): $(SRC_FORTUNES_DIR)/index.xhtml.tt2 $(DOCS_COMMON_DEPS) $(HUMOUR_DEPS) $(T2_FORTUNES_DIR)/Makefile $(T2_FORTUNES_DIR)/ver.txt

# TODO : extract a macro for this and the rule below.
$(FORTUNES_DEST_HTMLS): $(T2_DEST_FORTUNES_DIR)/%.html: lib/fortunes/xhtmls/%.toc-xhtml lib/fortunes/xhtmls/%.xhtml $(DOCS_COMMON_DEPS)

$(T2_FORTUNES_ALL__TEMP__HTML): $(T2_FORTUNES_ALL_WML) $(DOCS_COMMON_DEPS) $(FORTUNES_XHTMLS__FOR_INPUT_PORTIONS) $(FORTUNES_XHTMLS_TOCS)

$(DEST_HUMOUR)/fortunes/index.xhtml: $(FORTUNES_LIST__DEPS)

FORTS_EPUB_COVER = $(FORTUNES_XHTMLS_DIR)/shlomif-fortunes.jpg
FORTS_EPUB_SVG   = $(FORTUNES_XHTMLS_DIR)/shlomif-fortunes.svg

FORTS_EPUB_BASENAME = fortunes-shlomif.epub
FORTS_EPUB_DEST = $(T2_DEST_FORTUNES_DIR)/$(FORTS_EPUB_BASENAME)
FORTS_EPUB_SRC = $(FORTUNES_XHTMLS_DIR)/$(FORTS_EPUB_BASENAME)

$(FORTS_EPUB_SRC): fortunes-target
	cd $(FORTUNES_XHTMLS_DIR) && ebookmaker --output $(FORTS_EPUB_BASENAME) book.json

fortunes-epub: $(FORTS_EPUB_DEST)

fortunes-target: $(FORTUNES_TARGET) fortunes-compile-xmls $(T2_DEST_SHOW_CGI) $(T2_DEST_FORTUNE_SHOW_SCRIPT_TXT) $(FORTUNES_DEST_HTMLS) $(FORTS_EPUB_COVER)

$(FORTS_EPUB_COVER): $(FORTS_EPUB_SVG)
	inkscape --export-width=600 --export-png="$@" $< && \
	optipng "$@"

MOJOLICIOUS_LECTURE_SLIDE1 = $(T2_DEST)/lecture/Perl/Lightning/Mojolicious/mojolicious-slides.html

HACKING_DOC = $(T2_DEST)/open-source/resources/how-to-contribute-to-my-projects/HACKING.html

mojo_pres: $(MOJOLICIOUS_LECTURE_SLIDE1) $(HACKING_DOC)

$(MOJOLICIOUS_LECTURE_SLIDE1): $(T2_SRC_DIR)/lecture/Perl/Lightning/Mojolicious/mojolicious.asciidoc.txt
	asciidoctor --backend=xhtml5 -o $@ $<
	$(PERL) ./bin/clean-up-asciidoctor-xhtml5.pl $@

$(HACKING_DOC): $(T2_SRC_DIR)/open-source/resources/how-to-contribute-to-my-projects/HACKING.txt
	asciidoctor --backend=xhtml5 -o $@ $<
	$(PERL) ./bin/clean-up-asciidoctor-xhtml5.pl $@

all_deps: lib/htmls/The-Enemy-rev5.html-part

lib/htmls/The-Enemy-rev5.html-part: $(T2_SRC_DIR)/humour/TheEnemy/The-Enemy-Hebrew-rev5.xhtml.gz ./bin/extract-xhtml.pl
	gunzip < $< | $(PERL) ./bin/extract-xhtml.pl -o $@ -

all_deps: lib/htmls/The-Enemy-English-rev5.html-part

lib/htmls/The-Enemy-English-rev5.html-part: $(T2_SRC_DIR)/humour/TheEnemy/The-Enemy-English-rev5.xhtml.gz ./bin/extract-xhtml.pl
	gunzip < $< | $(PERL) ./bin/extract-xhtml.pl -o $@ -

all_deps: lib/htmls/The-Enemy-English-rev6.html-part

lib/htmls/The-Enemy-English-rev6.html-part: $(T2_SRC_DIR)/humour/TheEnemy/The-Enemy-English-rev6.xhtml.gz ./bin/extract-xhtml.pl
	gunzip < $< | $(PERL) ./bin/extract-xhtml.pl -o $@ -

DOCBOOK4_HHFG_IMAGES_RAW = \
	background-image.png \
	background-shlomif.png \
	bottom-shlomif.png \
	hhfg-bg-bottom.png \
	hhfg-bg-middle.png \
	hhfg-bg-top.png \
	style.css \
	top-shlomif.png

DOCBOOK4_HHFG_DEST_DIR = $(DEST_HUMOUR)/human-hacking/human-hacking-field-guide
DOCBOOK4_HHFG_IMAGES_DEST = $(addprefix $(DOCBOOK4_HHFG_DEST_DIR)/,$(DOCBOOK4_HHFG_IMAGES_RAW))

HHFG_V2_IMAGES_DEST_DIR_FROM_VCS = $(DEST_HUMOUR)/human-hacking/human-hacking-field-guide-v2--english
HHFG_V2_IMAGES_DEST_DIR = $(DEST_HUMOUR)/human-hacking/human-hacking-field-guide-v2
HHFG_V2_IMAGES_DEST = $(addprefix $(HHFG_V2_IMAGES_DEST_DIR)/,$(DOCBOOK4_HHFG_IMAGES_RAW))
HHFG_V2_IMAGES_DEST_FROM_VCS = $(addprefix $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/,$(DOCBOOK4_HHFG_IMAGES_RAW))

docbook_hhfg_images: $(DOCBOOK4_HHFG_IMAGES_DEST) $(HHFG_V2_IMAGES_DEST) $(HHFG_V2_IMAGES_DEST_FROM_VCS) $(HHFG_V2_IMAGES_DEST_DIR)/docbook.css

$(HHFG_V2_IMAGES_DEST_DIR)/docbook.css: lib/docbook/5/indiv-nodes/human-hacking-field-guide-v2--english/docbook.css
	mkdir -p "$$(dirname "$@")"
	cp -f $< $@

$(HHFG_V2_IMAGES_DEST_DIR)/index.xhtml: $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/index.xhtml
	mkdir -p $(HHFG_V2_IMAGES_DEST_DIR)
	cp -a $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/*.xhtml $(HHFG_V2_IMAGES_DEST_DIR)/

DOCBOOK5_DOCS += $(FICTION_DOCS)

include lib/make/docbook/sf-docbook-common.mak
include lib/make/docbook/sf-fictions.mak

FICTION_DB5S = $(patsubst %,$(DOCBOOK5_XML_DIR)/%.xml,$(FICTION_DOCS))
C_BAD_ELEMS_SRC = lib/c-begin/C-and-CPP-elements-to-avoid/c-and-cpp-elements-to-avoid.xml-grammar-vered.xml
DEST__C_BAD_ELEMS_SRC = $(T2_DEST)/lecture/C-and-CPP/bad-elements/c-and-cpp-elements-to-avoid.xml-grammar-vered.xml

$(DOCBOOK5_SOURCES_DIR)/c-and-cpp-elements-to-avoid.xml: $(C_BAD_ELEMS_SRC)
	./bin/translate-Vered-XML --output "$@" "$<"

all: $(DEST__C_BAD_ELEMS_SRC)

ART_SLOGANS_DOCS = \
	chromaticd/kiss-me-my-blog-post-got-chormaticd \
	CPP-supports-OOP/CPP-supports-OOP-as-much-as \
	dont-believe-in-fairies/dont-believe-in-fairies  \
	give-me-ascii/give-me-ASCII-or-give-me-death \
	lottery-all-you-need-is-a-dollar/lottery-all-you-need-is-a-dollar \
	what-do-you-mean-by-wdym/what-do-you-mean-by-wdym \

ART_SLOGANS_PATHS = $(addprefix $(T2_POST_DEST)/art/slogans/,$(ART_SLOGANS_DOCS))
ART_SLOGANS_PNGS = $(addsuffix .png,$(ART_SLOGANS_PATHS))
ART_SLOGANS_THUMBS = $(addsuffix .thumb.png,$(ART_SLOGANS_PATHS))

OPTIPNG = optipng -o7 -quiet

define EXPORT_INKSCAPE_PNG
	inkscape --export-width=200 --export-png="$@" $<
	$(OPTIPNG) $@
endef

include lib/make/long_stories.mak

PRINTER_ICON_PNG = $(T2_DEST)/images/printer_icon.png
TWITTER_ICON_20_PNG = $(T2_DEST)/images/twitter-bird-light-bgs-20.png
HHFG_SMALL_BANNER_AD_PNG = $(DEST_HUMOUR)/human-hacking/images/hhfg-ad-468x60.svg.preview.png

BK2HP_NEW_PNG = $(T2_DEST)/images/bk2hp.png

DEST_HTML_6_LOGO_PNG = $(DEST_HUMOUR)/bits/HTML-6/HTML-6-logo.png

$(BK2HP_NEW_PNG): lib/images/back_to_my_homepage_from_inkscape.png
	gm convert -matte -bordercolor none -border 5 $< $@
	$(OPTIPNG) $@

art_slogans_targets: $(ART_SLOGANS_THUMBS) $(BUFFY_A_FEW_GOOD_SLAYERS__SMALL_LOGO_PNG) $(THE_ENEMY_SMALL_LOGO_PNG) $(HHFG_SMALL_BANNER_AD_PNG) $(PRINTER_ICON_PNG) $(TWITTER_ICON_20_PNG) $(BK2HP_NEW_PNG) $(DEST_HTML_6_LOGO_PNG)

$(DEST_HTML_6_LOGO_PNG): $(T2_SRC_DIR)/humour/bits/HTML-6/HTML-6-logo.svg
	inkscape --export-dpi=60 --export-area-page --export-png="$@" "$<"
	$(OPTIPNG) $@

DEST_WINDOWS_UPDATE_SNAIL_ICON = $(DEST_HUMOUR)/bits/facts/images/windows-update-snail.png
DEST_FIERY_Q_PNG = $(DEST_HUMOUR)/Star-Trek/We-the-Living-Dead/images/fiery-Q.png

all: $(DEST_WINDOWS_UPDATE_SNAIL_ICON) $(DEST_FIERY_Q_PNG)

$(DEST_WINDOWS_UPDATE_SNAIL_ICON): $(T2_SRC_DIR)/humour/bits/facts/images/snail.svg
	inkscape --export-width=200 --export-png="$@" $<
	$(OPTIPNG) $@

$(ART_SLOGANS_PNGS): %.png: %.svg
	inkscape --export-png=$@ $<
	$(OPTIPNG) $@

$(ART_SLOGANS_THUMBS): %.thumb.png: %.png
	gm convert -resize '200' $< $@
	$(OPTIPNG) $@

$(PRINTER_ICON_PNG): common/images/printer_icon.svg
	inkscape --export-width=30 --export-png="$@" $<
	$(OPTIPNG) $@

$(TWITTER_ICON_20_PNG): common/images/twitter-bird-light-bgs.svg
	inkscape --export-width=30 --export-png="$@" $<
	$(OPTIPNG) $@

$(HHFG_SMALL_BANNER_AD_PNG): $(T2_SRC_DIR)/humour/human-hacking/images/hhfg-ad-468x60.svg.png
	gm convert -resize '50%' $< $@
	$(OPTIPNG) $@

LC_PRES_PATH = lecture/Lambda-Calculus/slides

LC_PRES_SCMS = \
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

LC_PRES_DEST_HTMLS = $(patsubst %.scm,$(T2_DEST)/$(LC_PRES_PATH)/%.scm.html,$(LC_PRES_SCMS))

lc_pres_targets: $(LC_PRES_DEST_HTMLS)

# Uses text-vimcolor from http://search.cpan.org/dist/Text-VimColor/
$(LC_PRES_DEST_HTMLS): $(T2_DEST)/%.scm.html: $(T2_SRC_DIR)/%.scm
	text-vimcolor --format html --full-page $< --output $@
	$(PERL) bin/fix-vimcolor.pl $@

SPORK_LECTURES_BASENAMES = \
	Perl/Graham-Function \
	Perl/Lightning/Opt-Multi-Task-in-PDL \
	Perl/Lightning/Test-Run \
	Perl/Lightning/Too-Many-Ways \
	SCM/subversion/for-pythoneers \
	Vim/beginners \

START_html := /start.html
SLIDES_start := /slides$(START_html)
SPORK_LECTS_SOURCE_BASE = lib/presentations/spork
GFUNC_PRES_BASE = $(SPORK_LECTS_SOURCE_BASE)/Perl/Graham-Function
GFUNC_PRES_DEST = $(T2_DEST)/lecture/Perl/Graham-Function
GFUNC_PRES_BASE_START = $(GFUNC_PRES_BASE)$(SLIDES_start)
GFUNC_PRES_DEST_START = $(GFUNC_PRES_DEST)$(SLIDES_start)

SPORK_LECTURES_DESTS := $(addprefix $(T2_DEST)/lecture/,$(SPORK_LECTURES_BASENAMES))
SPORK_LECTURES_DEST_STARTS := $(addsuffix $(SLIDES_start),$(SPORK_LECTURES_DESTS))
SPORK_LECTURES_BASE_STARTS := $(patsubst %,$(SPORK_LECTS_SOURCE_BASE)/%$(SLIDES_start),$(SPORK_LECTURES_BASENAMES))

graham_func_pres_targets: $(SPORK_LECTURES_DEST_STARTS)

start_html = $(patsubst %$(START_html),%/,$1)

$(SPORK_LECTURES_DEST_STARTS) : $(T2_DEST)/lecture/%$(START_html): $(SPORK_LECTS_SOURCE_BASE)/%$(START_html)
	rsync -a $(call start_html,$<) $(call start_html,$@)

$(SPORK_LECTURES_BASE_STARTS) : $(SPORK_LECTS_SOURCE_BASE)/%$(SLIDES_start) : $(SPORK_LECTS_SOURCE_BASE)/%/Spork.slides $(SPORK_LECTS_SOURCE_BASE)/%/config.yaml
	dn="$(patsubst %$(SLIDES_start),%,$@)" ; \
	   (cd "$$dn" && $(PERL) -MSpork::Shlomify -e 'Spork::Shlomify->new->load_hub->command->process(@ARGV)' -- -make) && $(PERL) bin/fix-spork.pl "$$dn"/slides/*.html && \
	cp -f common/favicon.png $(patsubst %$(START_html),%,$@)/

lib/presentations/spork/Vim/beginners/Spork.slides: lib/presentations/spork/Vim/beginners/Spork.slides.source
	< $< $(PERL) -pe 's!^\+!!' > $@

GEN_STYLE_CSS_FILES = style.css fortunes.css fortunes_show.css fort_total.css style-404.css screenplay.css jqui-override.css print.css

T2_CSS_TARGETS = $(addprefix $(T2_POST_DEST)/,$(GEN_STYLE_CSS_FILES))

css_targets: $(T2_CSS_TARGETS)

SASS_STYLE = compressed
# SASS_STYLE = expanded
SASS_CMD = sass --style $(SASS_STYLE)

FORT_SASS_DEPS = lib/sass/fortunes.scss
COMMON_SASS_DEPS = lib/sass/common-body.scss lib/sass/common-style.scss lib/sass/defs.scss

$(T2_CSS_TARGETS): $(T2_POST_DEST)/%.css: lib/sass/%.scss $(COMMON_SASS_DEPS)
	$(SASS_CMD) $< $@

$(T2_POST_DEST)/style.css $(T2_POST_DEST)/print.css: $(COMMON_SASS_DEPS) lib/sass/lang_switch.scss $(FORT_SASS_DEPS) lib/sass/code_block.scss lib/sass/jqtree.scss lib/sass/treeview.scss lib/sass/common-with-print.scss lib/sass/self_link.scss

$(T2_POST_DEST)/style.css: lib/sass/smoked-wp-theme.scss lib/sass/footer.scss

$(T2_POST_DEST)/fortunes_show.css: $(COMMON_SASS_DEPS)

Mater_CSS = $(T2_POST_DEST)/css/materialize.min.css
Mater_JS = $(T2_POST_DEST)/js/materialize.min.js

# non_latemp_targets: $(Mater_CSS) $(Mater_JS)

$(Mater_CSS): lib/sass/materialize/components/application.scss node_modules/materialize-css/sass/materialize.scss lib/sass/materialize/components/variables.scss
	$(SASS_CMD) -I $$PWD/lib/sass/materialize/ -I $$PWD/lib/sass/materialize/components/ -I node_modules/materialize-css/sass/ $< $@

$(Mater_JS):
	(cd node_modules/materialize-css/ && npm install . && grunt js_compile)
	cp -f node_modules/materialize-css/dist/js/materialize.min.js $@

$(T2_POST_DEST)/fort_total.css: $(FORT_SASS_DEPS) lib/sass/fortunes.scss lib/sass/fortunes_show.scss $(COMMON_SASS_DEPS) lib/sass/screenplay.scss

$(T2_DEST)/personal.html $(T2_DEST)/personal-heb.html: lib/pages/t2/personal.tt2
$(DEST_HUMOUR).html $(DEST_HUMOUR)-heb.html: lib/pages/t2/humour.tt2
$(T2_DEST)/work/hire-me/index.xhtml $(T2_DEST)/work/hire-me/hebrew.html: lib/pages/t2/hire-me.tt2

docbook_targets: pope_fiction selina_mandrake hhfg_fiction

$(T2_DEST)/lecture/Perl/Newbies/lecture5-heb-notes.html: $(T2_SRC_DIR)/lecture/Perl/Newbies/lecture5-notes.txt bin/lecture5-txt2html.bash

$(T2_DEST)/philosophy/by-others/perlcast-transcript--tom-limoncelli-interview/index.xhtml: lib/htmls/from-mediawiki/processed/Perlcast_Transcript_-_Interview_with_Tom_Limoncelli.html

HTML_TUT_BASE = lib/presentations/docbook/html-tutorial/hebrew-html-tutorial

HTML_TUT_HEB_DIR = $(HTML_TUT_BASE)/hebrew-html-tutorial
HTML_TUT_HEB_DB = $(HTML_TUT_BASE)/hebrew-html-tutorial.xml
HTML_TUT_HEB_TT = $(HTML_TUT_BASE)/hebrew-html-tutorial.xml.tt
DEST_HTML_TUT_BASE = $(T2_DEST)/lecture/HTML-Tutorial/v1/xhtml1/hebrew
DEST_HTML_TUT = $(DEST_HTML_TUT_BASE)/index.xhtml

selina_mandrake: $(SELINA_MANDRAKE_ENG_SCREENPLAY_XML_SOURCE) $(SELINA_MANDRAKE_ENG_TXT_FROM_VCS) $(SELINA_MANDRAKE_ENG_FRON_IMAGE__DEST) $(QOHELETH_IMAGES__DEST) $(TERM_LIBERATION_IMAGES__DEST)

pope_fiction: $(POPE_ENG_FICTION_XML_SOURCE)

hhfg_fiction: $(HHFG_ENG_DOCBOOK5_SOURCE) $(HHFG_HEB_FICTION_XML_SOURCE)

screenplay_targets: $(ST_WTLD_TEXT_IN_TREE) $(SCREENPLAY_XMLS) $(SCREENPLAY_HTMLS) $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_SOURCES_ON_DEST) $(FICTION_TEXT_SOURCES_ON_DEST) $(SCREENPLAY_XML_FOR_OOO_XHTMLS) $(SELINA_MANDRAKE_ENG_SCREENPLAY_XML_SOURCE) $(SUMMERSCHOOL_AT_THE_NSA_ENG_SCREENPLAY_XML_SOURCE) screenplay_epub_dests

$(DEST_HTML_TUT): $(HTML_TUT_HEB_HTML)
	mkdir -p $(DEST_HTML_TUT_BASE)
	rsync -r $(HTML_TUT_HEB_DIR)/ $(DEST_HTML_TUT_BASE)

$(HTML_TUT_HEB_DB): $(HTML_TUT_HEB_TT)
	cd $(HTML_TUT_BASE) && gmake docbook

$(HTML_TUT_HEB_TT):
	cd lib/presentations/docbook && git clone https://github.com/shlomif/html-tutorial

update_html_tut: update_html_tut_hg html_tutorial

update_html_tut_hg:
	cd $(HTML_TUT_BASE) && (git pull)

include lib/make/deps.mak

MATHJAX_DEST_DIR = $(T2_DEST)/js/MathJax
MATHJAX_DEST_README = $(MATHJAX_DEST_DIR)/README.md

mathjax_dest: make-dirs $(MATHJAX_DEST_README)

$(MATHJAX_DEST_README): $(MATHJAX_SOURCE_README)
	rsync -r --exclude='**/.git/**' lib/js/MathJax/ $(T2_DEST)/js/MathJax/
	rm -fr $(MATHJAX_DEST_DIR)/.git
	rm -fr $(MATHJAX_DEST_DIR)/.gitignore
	rm -fr $(MATHJAX_DEST_DIR)/test

SCRIPTS_WITH_OFFENDING_EXTENSIONS = MathVentures/gen-bugs-in-square-svg.pl open-source/bits-and-bobs/nowplay-xchat.pl open-source/bits-and-bobs/pmwiki-revert.pl open-source/bits-and-bobs/convert-kabc-dist-lists.pl

SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS = $(patsubst %.pl,$(T2_DEST)/%-pl.txt,$(SCRIPTS_WITH_OFFENDING_EXTENSIONS))

plaintext_scripts_with_offending_extensions: $(SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS)

T2_DEST_IMAGES_DIR = $(T2_DEST)/images

SVG_NAV_IMAGES = \
	$(T2_DEST_IMAGES_DIR)/sect-arr-left-disabled.svg \
	$(T2_DEST_IMAGES_DIR)/sect-arr-left-pressed.svg \
	$(T2_DEST_IMAGES_DIR)/sect-arr-left.svg \
	$(T2_DEST_IMAGES_DIR)/sect-arr-right-disabled.svg \
	$(T2_DEST_IMAGES_DIR)/sect-arr-right-pressed.svg \
	$(T2_DEST_IMAGES_DIR)/sect-arr-right.svg \
	$(T2_DEST_IMAGES_DIR)/sect-arr-up-disabled.svg \
	$(T2_DEST_IMAGES_DIR)/sect-arr-up-pressed.svg \
	$(T2_DEST_IMAGES_DIR)/sect-arr-up.svg

svg_nav_images: $(SVG_NAV_IMAGES)

$(SVG_NAV_IMAGES): lib/images/navigation/section/sect-nav-arrows.pl
	$(PERL) $< $(T2_DEST_IMAGES_DIR)

NAV_DATA_AS_JSON = $(T2_DEST)/_data/nav.json

generate_nav_data_as_json: $(NAV_DATA_AS_JSON)

$(NAV_DATA_AS_JSON): $(NAV_DATA_DEP) $(NAV_DATA_AS_JSON_BIN) lib/Shlomif/Homepage/NavData/JSON.pm $(ALL_SUBSECTS_DEPS)
	./$(NAV_DATA_AS_JSON_BIN) -o $@

$(T2_DEST)/site-map/index.xhtml: $(ALL_SUBSECTS_DEPS)

JQTREE_SRC := common/js/tree.jquery.js
JQTREE_MIN_DEST := $(T2_DEST)/js/tree.jq.js
MAIN_TOTAL_MIN_JS_DEST := $(T2_DEST)/js/main_all.js
EXPANDER_MIN_JS_DEST := $(T2_DEST)/js/jquery.expander.min.js
EXPANDER_JS_DEST := $(T2_DEST)/js/jquery.expander.js
EXPANDER_JS_SRC := lib/js/jquery-expander/jquery.expander.js
MULTI_YUI = ./bin/Run-YUI-Compressor

$(EXPANDER_MIN_JS_DEST): $(EXPANDER_JS_SRC)
	$(MULTI_YUI) -o $@ $<

# Must not be sorted!
MAIN_TOTAL_MIN_JS__SOURCES = \
	common/js/jq.js \
	common/js/jquery.treeview.min.js \
	common/js/toggler.js \
	common/js/toggle_sect.js \
	common/js/tree.jquery.js \
	common/js/jquery.cookie.js \
	common/js/to-jqtree.js \
	common/js/to-jqtree-2.js \
	common/js/selfl.js \
	common/js/sub_menu.js \

$(JQTREE_MIN_DEST): $(JQTREE_SRC) $(MULTI_YUI)
	$(MULTI_YUI) -o $@ $(JQTREE_SRC)

minified_javascripts: $(JQTREE_MIN_DEST) $(MAIN_TOTAL_MIN_JS_DEST) $(EXPANDER_MIN_JS_DEST) $(EXPANDER_JS_DEST)

$(MAIN_TOTAL_MIN_JS_DEST): $(MULTI_YUI) $(MAIN_TOTAL_MIN_JS__SOURCES)
	$(MULTI_YUI) -o $@ $(MAIN_TOTAL_MIN_JS__SOURCES)

PRINTABLE_DEST_DIR := dest/printable
PRINTABLE_RESUMES__HTML__PIVOT = $(PRINTABLE_DEST_DIR)/Shlomi-Fish-English-Resume-Detailed.html
PRINTABLE_RESUMES__HTML = $(PRINTABLE_RESUMES__HTML__PIVOT) $(addprefix $(PRINTABLE_DEST_DIR)/,Shlomi-Fish-English-Resume.html Shlomi-Fish-Heb-Resume.html Shlomi-Fish-Resume-as-Software-Dev.html)


printable_resumes__html : $(PRINTABLE_RESUMES__HTML__PIVOT)

PRINTABLE_RESUMES__DOCX = $(patsubst %.html,%.docx,$(PRINTABLE_RESUMES__HTML))

$(PRINTABLE_RESUMES__DOCX): %.docx: %.html
	libreoffice --writer --headless --convert-to docx --outdir $(PRINTABLE_DEST_DIR) $<

$(PRINTABLE_RESUMES__HTML__PIVOT): $(T2_DEST)/SFresume.html $(T2_DEST)/SFresume_detailed.html $(T2_DEST)/me/resumes/Shlomi-Fish-Heb-Resume.html $(T2_DEST)/me/resumes/Shlomi-Fish-Resume-as-Software-Dev.html
	bash bin/gen-printable-CVs.sh
	$(PERL) -lp -0777 -e 's#\A<\?xml ver.*?\?>##' < $(T2_DEST)/me/resumes/Shlomi-Fish-Heb-Resume.html > $(PRINTABLE_DEST_DIR)/Shlomi-Fish-Heb-Resume.html
	cp -f $(PRINTABLE_DEST_DIR)/SFresume.html $(PRINTABLE_DEST_DIR)/Shlomi-Fish-English-Resume.html
	cp -f $(PRINTABLE_DEST_DIR)/SFresume_detailed.html $(PRINTABLE_DEST_DIR)/Shlomi-Fish-English-Resume-Detailed.html

resumes: $(PRINTABLE_RESUMES__DOCX)

PUT_CARDS_2013_DEST_INDIV = $(T2_DEST)/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/tie_your_camel.xhtml
PUT_CARDS_2013_INDIV_SCRIPT = bin/split-put-cards-into-divs.pl

all: $(PUT_CARDS_2013_DEST_INDIV)

$(PUT_CARDS_2013_DEST_INDIV): $(PUT_CARDS_2013_XHTML) $(PUT_CARDS_2013_INDIV_SCRIPT)
	$(PERL) $(PUT_CARDS_2013_INDIV_SCRIPT)

FACTOIDS_RENDER_SCRIPT = lib/factoids/gen-html.pl
FACTOIDS_TIMESTAMP = lib/factoids/TIMESTAMP
FACTOIDS_GENERATED_FILES = lib/factoids/indiv-lists-xhtmls/buffy_facts--en-US.xhtml.reduced
FACTOIDS_GEN_CMD = $(PERL) $(FACTOIDS_RENDER_SCRIPT)

# FACTOIDS_DOCS_DEST = $(filter $(DEST_HUMOUR)/bits/facts/%,$(T2_DOCS_DEST))

$(FACTOIDS_TIMESTAMP): $(FACTOIDS_RENDER_SCRIPT) lib/factoids/shlomif-factoids-lists.xml
	$(FACTOIDS_GEN_CMD)

all: $(FACTOIDS_TIMESTAMP)

include lib/factoids/deps.mak

# $(FACTOIDS_DOCS_DEST): $(FACTOIDS_GENERATED_FILES)

all: manifest_html

manifest_html: $(MAN_HTML)

$(FACTOIDS_NAV_JSON):
	$(FACTOIDS_GEN_CMD)

LC_LECTURE_ARC_BASE = Lambda-Calculus.tar.gz
LC_LECTURE_ARC_DIR = $(T2_DEST)/lecture
LC_LECTURE_ARC = $(LC_LECTURE_ARC_DIR)/$(LC_LECTURE_ARC_BASE)

all: $(LC_LECTURE_ARC)

$(LC_LECTURE_ARC): $(LC_LECTURE_ARC_DIR)/Lambda-Calculus/slides/funcs.scm.html
	(cd $(LC_LECTURE_ARC_DIR) && touch -d 2019-03-31T10:00:00Z Lambda-Calculus/slides/* && tar -cavf $(LC_LECTURE_ARC_BASE) Lambda-Calculus/slides/*)

lib/Shlomif/Homepage/SectionMenu/Sects/Humour.pm : $(FORTUNES_LIST__DEPS) $(FACTOIDS_NAV_JSON)
	touch $@

OCT_2014_SGLAU_LET_DIR = $(T2_SRC_DIR)/philosophy/SummerNSA/Letter-to-SGlau-2014-10
OCT_2014_SGLAU_LET_PDF = $(OCT_2014_SGLAU_LET_DIR)/letter-to-sglau.pdf
OCT_2014_SGLAU_LET_HTML = $(OCT_2014_SGLAU_LET_DIR)/letter-to-sglau.xhtml

MY_NAME_IS_RINDOLF_SRC = $(T2_POST_DEST)/me/rindolf/images/my-name-is-rindolf.jpg
MY_NAME_IS_RINDOLF_DEST = $(T2_POST_DEST)/me/rindolf/images/my-name-is-rindolf-200w.jpg
Shlomif_cutethulhu_SRC = common/images/shlomif-cutethulhu.webp
Shlomif_cutethulhu_DEST = $(T2_POST_DEST)/images/shlomif-cutethulhu-small.webp
DnD_lances_cartoon_DEST = $(T2_POST_DEST)/art/d-and-d-cartoon--comparing-lances/d-and-d-cartoon-exported.webp

T2_POST_DEST__HUMOUR_IMAGES := $(T2_POST_DEST)/humour/images

Holocaust_DEST = $(T2_POST_DEST__HUMOUR_IMAGES)/Holocaust.webp
Yo_NSA_DEST = $(T2_POST_DEST__HUMOUR_IMAGES)/NSA-publish-or-perish.svg.webp
Philosophers_Pbride_DEST = $(T2_POST_DEST__HUMOUR_IMAGES)/philosophers-princess-bride.svg.webp
Nothing_Sexier_DEST = $(T2_POST_DEST__HUMOUR_IMAGES)/Nothing-Sexier.svg.webp
Slp_pinned_it_DEST = $(T2_POST_DEST__HUMOUR_IMAGES)/SLP-excerpt-pinned-it-on-me.webp
Truly_you_have_DEST = $(T2_POST_DEST__HUMOUR_IMAGES)/Truly-You-Have.svg.webp
Klingon_Warrior_Sesame_DEST = $(T2_POST_DEST__HUMOUR_IMAGES)/Every-mighty-Klingon-Warrior.svg.webp
MY_RPF_DEST_DIR = $(T2_POST_DEST)/philosophy/culture/my-real-person-fan-fiction
MY_RPF_DEST_PIVOT = $(MY_RPF_DEST_DIR)/euler.webp
OPENLY_BIPOLAR_DEST_DIR = $(T2_POST_DEST)/philosophy/psychology/why-openly-bipolar-people-should-not-be-medicated/
OPENLY_BIPOLAR_DEST_PIVOT = $(OPENLY_BIPOLAR_DEST_DIR)/alan_turing.webp

all: $(OCT_2014_SGLAU_LET_PDF) $(OCT_2014_SGLAU_LET_HTML)

all: $(MY_NAME_IS_RINDOLF_DEST) $(Shlomif_cutethulhu_DEST) $(Holocaust_DEST) $(Yo_NSA_DEST) $(Philosophers_Pbride_DEST) $(Nothing_Sexier_DEST) $(Truly_you_have_DEST) $(Slp_pinned_it_DEST) $(Klingon_Warrior_Sesame_DEST) $(DnD_lances_cartoon_DEST)

all: $(MY_RPF_DEST_PIVOT) $(OPENLY_BIPOLAR_DEST_PIVOT)

MY_RPF_SRC_DIR = lib/repos/my-real-person-fan-fiction

$(MY_RPF_DEST_PIVOT): $(MY_RPF_SRC_DIR)/euler.webp $(MY_RPF_DEST_DIR)
	cp -f $(MY_RPF_SRC_DIR)/*.webp $(MY_RPF_DEST_DIR)/

OPENLY_BIPOLAR_SRC_DIR = lib/repos/why-openly-bipolar-people-should-not-be-medicated

$(OPENLY_BIPOLAR_DEST_PIVOT): $(OPENLY_BIPOLAR_SRC_DIR)/alan_turing.webp $(OPENLY_BIPOLAR_DEST_DIR)
	cp -f $(OPENLY_BIPOLAR_SRC_DIR)/*.webp $(OPENLY_BIPOLAR_DEST_DIR)/

$(Klingon_Warrior_Sesame_DEST): lib/repos/Captioned-Image-Every-mighty-Klingon-Warrior/Every-mighty-Klingon-Warrior.svg.webp
	$(call COPY)

$(Nothing_Sexier_DEST): lib/repos/Captioned-Image-Nothing-Sexier/Nothing-Sexier.svg.webp
	$(call COPY)

$(DnD_lances_cartoon_DEST): t2/art/d-and-d-cartoon--comparing-lances/d-and-d-cartoon-exported.png
	gm convert $< $@

lib/docbook/5/xml/putting-cards-on-the-table-2019-2020.xml: lib/repos/putting-cards-2019-2020/shlomif-putting-cards-on-the-table-2019-2020.docbook5.xml
	$(call COPY)

$(Slp_pinned_it_DEST): lib/repos/Captioned-Image-SLP-Pinned-It-On-Me/SLP-excerpt-pinned-it-on-me--400w.webp
	$(call COPY)

$(Truly_you_have_DEST): lib/repos/Captioned-Image-Truly-You-Have/Truly-You-Have.svg.webp
	$(call COPY)

$(Philosophers_Pbride_DEST): lib/repos/Captioned-Image-Princess-Bride-Greek-Philosophers/philosophers-princess-bride.svg.webp
	$(call COPY)

$(Yo_NSA_DEST): lib/repos/Captioned-Image-Yo-NSA-Publish-or-Perish/NSA-publish-or-perish.svg.webp
	$(call COPY)

$(Holocaust_DEST): lib/repos/Captioned-Image-Holocaust/Holocaust.png
	gm convert $< $@

$(OCT_2014_SGLAU_LET_PDF): $(T2_SRC_DIR)/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.odt
	export A="$$PWD" ; cd $(OCT_2014_SGLAU_LET_DIR) && oowriter --headless --convert-to pdf "$$A/$<"

$(OCT_2014_SGLAU_LET_HTML): $(T2_SRC_DIR)/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.odt
	export A="$$PWD" ; cd $(OCT_2014_SGLAU_LET_DIR) && oowriter --headless --convert-to xhtml "$$A/$<"

$(MY_NAME_IS_RINDOLF_DEST): $(MY_NAME_IS_RINDOLF_SRC)
	gm convert -resize '200' $< $@

$(Shlomif_cutethulhu_DEST): $(Shlomif_cutethulhu_SRC)
	gm convert -resize '170x' $< $@

ENEMY_STYLE = $(T2_DEST)/humour/TheEnemy/The-Enemy-English-v7/style.css

all: $(ENEMY_STYLE)

$(ENEMY_STYLE):
	mkdir -p "$$(dirname "$@")"
	touch $@

tags:
	ctags -R --exclude='.git/**' --exclude='*~' .

$(T2_DOCS_DEST): $(T2_DEST)/%: \
	$(T2_CACHE_PREF)/%/breadcrumbs-trail \
	$(T2_CACHE_PREF)/%/html_head_nav_links \
	$(T2_CACHE_PREF)/%/main_nav_menu_html \
	$(T2_CACHE_PREF)/%/page_url \
	$(T2_CACHE_PREF)/%/sect-navmenu \
	$(T2_CACHE_PREF)/%/shlomif_nav_links_renderer-with_accesskey= \
	$(T2_CACHE_PREF)/%/shlomif_nav_links_renderer-with_accesskey=1 \

SRC_MODS_DIR = lib/assets/mods

MODS := $(shell cd $(SRC_MODS_DIR) && ls *.{s3m,xm,mod})

ZIP_MODS = $(addsuffix .zip,$(MODS))
XZ_MODS = $(addsuffix .xz,$(MODS))

DEST_MODS_DIR = $(T2_DEST)/Iglu/shlomif/mods
dest_mods = $(addprefix $(DEST_MODS_DIR)/,$(1))
DEST_ZIP_MODS = $(call dest_mods,$(ZIP_MODS))
DEST_XZ_MODS = $(call dest_mods,$(XZ_MODS))

mod_files: $(DEST_ZIP_MODS) $(DEST_XZ_MODS)

$(DEST_XZ_MODS): $(DEST_MODS_DIR)/%.xz: $(SRC_MODS_DIR)/%
	xz -9 --extreme < $< > $@

$(DEST_ZIP_MODS): $(DEST_MODS_DIR)/%.zip: $(SRC_MODS_DIR)/%
	bn='$(patsubst $(SRC_MODS_DIR)/%,%,$<)'; \
	(cd $(SRC_MODS_DIR) && zip -9 "$$bn.zip" "$$bn" ; ) ;  \
	mv -f "$(SRC_MODS_DIR)/$$bn.zip" $@

TECH_BLOG_DIR = lib/repos/shlomif-tech-diary
TECH_TIPS_SCRIPT = $(TECH_BLOG_DIR)/extract-tech-tips.pl
TECH_TIPS_INPUTS = $(addprefix $(TECH_BLOG_DIR)/,old-tech-diary.xhtml tech-diary.xhtml)
TECH_TIPS_OUT = lib/repos/shlomif-tech-diary--tech-tips.xhtml

$(TECH_TIPS_OUT): $(TECH_TIPS_SCRIPT) $(TECH_TIPS_INPUTS)
	$(PERL) $(TECH_TIPS_SCRIPT) $(addprefix --file=,$(TECH_TIPS_INPUTS)) --output $@ --nowrap

$(T2_DEST)/open-source/resources/tech-tips/index.xhtml: $(TECH_TIPS_OUT)
all_deps: $(TECH_TIPS_OUT)

$(T2_DEST)/philosophy/computers/web/validate-your-html/index.xhtml: lib/repos/validate-your-html/README.md
$(T2_DEST)/philosophy/computers/how-to-share-code-for-getting-help/index.xhtml: lib/repos/how-to-share-code-online/README.md

all: $(T2_CLEAN_STAMP) $(T2_POST_DEST_SHOW_CGI)

$(T2_FORTUNES_ALL__HTML__POST) $(T2_POST_DEST_SHOW_CGI): $(T2_CLEAN_STAMP)

PROC_INCLUDES_COMMON := APPLY_TEXTS=1 xargs $(PROCESS_ALL_INCLUDES__NON_INPLACE) --mode=minify --minifier-conf=bin/html-min-cli-config-file.conf --texts-dir=lib/ads --source-dir=$(T2_DEST) --dest-dir=$(T2_POST_DEST) --
STRIP_T2_DEST := $(PERL) -lpe 's=\A(?:./)?$(T2_DEST)/?=='
find_htmls = find $(1) -name '*.html' -o -name '*.xhtml'

WMLect_PATH := lecture/WebMetaLecture/slides/examples

$(T2_CLEAN_STAMP): $(T2_DOCS_DEST) $(PRES_TARGETS_ALL_FILES) $(SPORK_LECTURES_DEST_STARTS) $(MAN_HTML) $(BK2HP_NEW_PNG) $(MATHJAX_DEST_README) $(T2_DEST_SHOW_CGI)
	$(call find_htmls,$(T2_DEST)) | grep -vF -e philosophy/by-others/sscce -e WebMetaLecture/slides/examples -e homesteading/catb-heb -e $(T2_SRC_DIR)/catb-heb.html | $(STRIP_T2_DEST) | $(PROC_INCLUDES_COMMON)
	rsync --exclude '*.html' --exclude '*.xhtml' -a $(T2_DEST)/ $(T2_POST_DEST)/
	find $(T2_POST_DEST) -name '*.epub' | xargs -n 1 -P 4 strip-nondeterminism --type zip
	rsync -a $(T2_DEST)/$(WMLect_PATH)/ $(T2_POST_DEST)/$(WMLect_PATH)
	touch $@

VIM_IFACE_BN := VimIface.pm
QP_VIM_IFACE := lib/presentations/qp/common/$(VIM_IFACE_BN)

all: $(QP_VIM_IFACE)

FASTRENDER_DEPS := $(T2_DOCS_SRC) all_deps

fastrender: $(FASTRENDER_DEPS) fastrender-tt2 $(T2_FORTUNES_ALL__HTML)

fastrender-tt2: $(FASTRENDER_DEPS)
	@echo $(MAKE) fastrender-tt2
	perl bin/tt-render.pl

T2_jpgs__BASE := $(filter $(T2_POST_DEST)/humour/bits/facts/%.jpg,$(T2_IMAGES_DEST))
T2_jpgs__webps :=$(T2_jpgs__BASE:%.jpg=%.webp)
$(T2_jpgs__webps): %.webp: %.jpg
	gm convert $< $@

T2_SVGS__BASE := $(filter %.svg,$(T2_IMAGES_DEST))
T2_SVGS__MIN := $(T2_SVGS__BASE:%.svg=%.min.svg)
T2_SVGS__svgz := $(T2_SVGS__BASE:%.svg=%.svgz)

$(T2_SVGS__MIN): %.min.svg: %.svg
	minify --svg-decimals 3 -o $@ $<

$(T2_SVGS__svgz): %.svgz: %.min.svg
	gzip --best -n < $< > $@

min_svgs: $(T2_SVGS__MIN) $(T2_SVGS__svgz) $(BK2HP_SVG_SRC) $(T2_jpgs__webps)

TEST_TARGETS = Tests/*.{py,t}

T2_DEST_FORTUNES_many_files := $(T2_DEST_FORTUNES) $(T2_DEST_FORTUNES_SQLITE_DB)

include lib/make/copies-generated-include.mak
include lib/make/docbook/screenplays-copy-operations.mak

screenplay_targets: $(SCREENPLAY_SOURCES_ON_DEST__EXTRA_TARGETS)
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

$(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.xhtml: \
	$(DOCBOOK5_RENDERED_DIR)/fiction-text-example-for-X-G-Fiction-demo.xhtml \
	$(FICTION_XML_TXT_DIR)/fiction-text-example-for-X-G-Fiction-demo.txt \
	$(SCREENPLAY_XML_RENDERED_HTML_DIR)/humanity-excerpt-for-X-G-Screenplay-demo.html \
	$(SCREENPLAY_XML_TXT_DIR)/humanity-excerpt-for-X-G-Screenplay-demo.txt \

$(DOCBOOK5_BASE_DIR)/xml/Spark-Pre-Birth-of-a-Modern-Lisp.xml: $(T2_SRC_DIR)/open-source/projects/Spark/mission/Spark-Pre-Birth-of-a-Modern-Lisp.txt
	asciidoctor --backend=docbook5 -o $@.temp.xml $<
	xsltproc bin/clean-up-asciidoctor-docbook5.xslt $@.temp.xml > $@

JSON_RES_BASE = me/resumes/Shlomi-Fish-Resume.jsonresume

JSON_RES_DEST := $(T2_DEST)/$(JSON_RES_BASE).json

$(JSON_RES_DEST): $(T2_SRC_DIR)/$(JSON_RES_BASE).yaml
	$(PERL) bin/my-yaml-2-canonical-json.pl -i $< -o $@

non_latemp_targets: $(JSON_RES_DEST) $(T2_SRC_FORTUNE_SHOW_PY)

$(MAN_HTML): ./bin/gen-manifest.pl $(ENEMY_STYLE) $(ALL_HTACCESSES) $(SPORK_LECTURES_DEST_STARTS)
	$(PERL) $<

catb_copy = $(T2_DEST)/catb-heb.xhtml
catb_copy_post = $(T2_POST_DEST)/catb-heb.xhtml

$(catb_copy): t2/homesteading/catb-heb.xhtml
	$(call COPY)

all_deps: $(catb_copy)

$(catb_copy_post): $(catb_copy)
	$(call COPY)

all: $(catb_copy_post)

copy_fortunes: $(T2_DEST_FORTUNES_many_files)
