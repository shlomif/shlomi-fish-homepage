# Whether this is the development environment
DEV = 0

DEV_WML_FLAGS :=

ifeq ($(DEV),1)
	DEV_WML_FLAGS := -DLATEMP_IS_DEV_ENV=1
endif

ALL_DEST_BASE = dest

all: sects_cache docbook_targets fortunes-target latemp_targets css_targets sitemap_targets copy_fortunes site-source-install presentations_targets lc_pres_targets art_slogans_targets graham_func_pres_targets mojo_pres hhgg_convert lib/MathJax/README.md plaintext_scripts_with_offending_extensions svg_nav_images generate_nav_data_as_json minified_javascripts mathjax_dest htaccesses_target printable_resumes__html mod_files

include lib/make/shlomif_common.mak
include lib/make/include.mak
include lib/make/rules.mak

WML_FLAGS += --passoption=2,-X3074 --passoption=2,-I../lib/ \
	--passoption=3,-I../lib/ \
	--passoption=3,-w -I../lib/ $(LATEMP_WML_FLAGS) \
	-p1-3,5,7 \
	-DROOT~. -DLATEMP_THEME=sf.org1 \
	-I $${HOME}/apps/wml \
	$(DEV_WML_FLAGS)

NAV_DATA_DEP = lib/MyNavData.pm
NAV_DATA_AS_JSON_BIN = bin/nav-data-as-json

SCREENPLAY_COMMON_INC_DIR = $(PWD)/lib/screenplay-xml/from-vcs/screenplays-common

DOCS_COMMON_DEPS = lib/template.wml $(NAV_DATA_DEP)

MATHJAX_SOURCE_README = lib/MathJax/README.md

FORTUNES_DIR = humour/fortunes
T2_FORTUNES_DIR = t2/$(FORTUNES_DIR)

include $(T2_FORTUNES_DIR)/arcs-list.mak
include $(T2_FORTUNES_DIR)/fortunes-list.mak

T2_ALL_DIRS_DEST = $(T2_DIRS_DEST) $(T2_COMMON_DIRS_DEST)

PROCESS_ALL_INCLUDES = perl bin/post-incs.pl

# WML_LATEMP_PATH="$$(perl -MFile::Spec -e 'print File::Spec->rel2abs(shift)' '$@')" ;
define DEF_WML_PATH
fn="$$PWD/$@" ;
endef

define GENERIC_GENERIC_WML_RENDER
$(call DEF_WML_PATH) ( cd $2 && wml -o "$$fn" $(WML_FLAGS) -DLATEMP_FILENAME=$(patsubst $3/%,%,$(patsubst %.wml,%,$@)) $(patsubst $2/%,%,$<) ) && $4 '$@'
endef

define GENERIC_WML_RENDER
$(call GENERIC_GENERIC_WML_RENDER,$1,$2,$3,$(PROCESS_ALL_INCLUDES))
endef

define T2_INCLUDE_WML_RENDER
$(call GENERIC_WML_RENDER,t2,$(T2_SRC_DIR),$(T2_DEST))
endef

define T2_COMMON_INCLUDE_WML_RENDER
$(call GENERIC_WML_RENDER,t2,$(COMMON_SRC_DIR),$(T2_DEST))
endef

make-dirs: $(T2_ALL_DIRS_DEST)

GEN_SECT_NAV_MENUS = ./bin/gen-sect-nav-menus.pl

FORTUNES_ALL_IN_ONE__BASE = all-in-one.html
FORTUNES_ALL_IN_ONE__TEMP__BASE = all-in-one.uncompressed.html
T2_FORTUNES_ALL_WML = $(T2_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__TEMP__BASE).wml
T2_FORTUNES_ALL__HTML = $(T2_DEST_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__BASE)
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

T2_CACHE_ALL_STAMP = lib/cache/STAMP.one
T2_CLEAN_STAMP = lib/cache/STAMP.two

T2_CACHE_PREF = lib/cache/combined/t2

T2_CACHE_ALL_DOCS = $(patsubst $(T2_DEST)/%,$(T2_CACHE_PREF)/%/sect-navmenu,$(T2_DOCS_DEST))

$(T2_CACHE_ALL_STAMP): $(GEN_SECT_NAV_MENUS) $(FACTOIDS_NAV_JSON) $(ALL_SUBSECTS_DEPS)
	perl $(GEN_SECT_NAV_MENUS) $(T2_DOCS) $(COMMON_DOCS) $(FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__TEMP__BASE) $(FORTUNES_DIR)/index.html $(patsubst %,$(FORTUNES_DIR)/%.html,$(FORTUNES_FILES_BASE))
	touch $@

sects_cache: make-dirs $(T2_CACHE_ALL_STAMP)

SITE_SOURCE_INSTALL_TARGET = $(T2_DEST)/meta/site-source/INSTALL
T2_DEST_FORTUNES_DIR = $(T2_DEST)/$(FORTUNES_DIR)
FORTUNES_TARGET =  $(T2_DEST_FORTUNES_DIR)/index.html

site-source-install: $(SITE_SOURCE_INSTALL_TARGET)

all: $(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-hebrew.xml
all: $(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-english.xml

T2_DEST_SHOW_CGI = $(T2_DEST_FORTUNES_DIR)/show.cgi
T2_SRC_FORTUNE_SHOW_SCRIPT = $(T2_SRC_DIR)/$(FORTUNES_DIR)/show.cgi
T2_DEST_FORTUNE_SHOW_SCRIPT_TXT = $(T2_DEST_FORTUNES_DIR)/show-cgi.txt

T2_FORTUNES_DIR_HTACCESS = $(T2_DEST_FORTUNES_DIR)/.htaccess

ALL_HTACCESSES = $(T2_FORTUNES_DIR_HTACCESS) $(T2_DEST)/humour/humanity/songs/.htaccess $(T2_DEST)/lecture/PostgreSQL-Lecture/.htaccess

htaccesses_target: $(ALL_HTACCESSES)

$(T2_FORTUNES_DIR)/my_htaccess.conf: $(T2_FORTUNES_DIR)/gen-htaccess.pl
	(cd $(T2_FORTUNES_DIR) && make)

$(ALL_HTACCESSES): $(T2_DEST)/%/.htaccess: $(T2_SRC_DIR)/%/my_htaccess.conf
	$(call COPY)

$(T2_FORTUNES_ALL_WML): bin/gen-forts-all-in-one-page.pl $(FORTUNES_LIST_PM)
	perl -Ilib $< $@

# t2 macros

T2_DEST_FORTUNES = $(patsubst %,$(T2_DEST_FORTUNES_DIR)/%,$(FORTUNES_ARCS_LIST))

$(T2_DEST_FORTUNES): $(T2_DEST)/%: $(T2_SRC_DIR)/%
	$(call COPY)

$(T2_DEST_SHOW_CGI): $(T2_SRC_FORTUNE_SHOW_SCRIPT)
	$(call COPY)
	chmod +x $@

$(T2_DEST_FORTUNE_SHOW_SCRIPT_TXT): $(T2_SRC_FORTUNE_SHOW_SCRIPT)
	$(call COPY)
	chmod -x $@

copy_fortunes: $(T2_DEST_FORTUNES)

define UPLOAD
(cd $(T2_DEST) && $(RSYNC) -a . $1 )
endef

upload_deps: all

upload_local: upload_deps
	$(call UPLOAD,$${HOMEPAGE_SSH_PATH})

upload_backup: upload_deps
	$(call UPLOAD,shlomif@alberni.textdrive.com:domains/www-backup.shlomifish.org/web/public)

upload: upload_remote

upload_remote: upload_local upload_remote_only

upload_remote_only: upload_deps upload_remote_only_without_deps

upload_remote_only_without_deps:
	$(call UPLOAD,$${__HOMEPAGE_REMOTE_PATH})

upload_adbrite_only: upload_deps
	$(call UPLOAD,$${__HOMEPAGE_REMOTE_PATH}/adbrite-ie8-breakage/)

upload_var: upload_deps upload_var_without_deps

upload_var_without_deps:
	$(call UPLOAD,/var/www/html/shlomif/homepage-local/)

upload_beta: upload_deps
	$(call UPLOAD,$${__HOMEPAGE_REMOTE_PATH}/__Beta-kmor)

upload_all: upload upload_var upload_local upload_beta

clean:

upload_hostgator: upload_deps
	$(call UPLOAD,'hostgator:public_html/')

t2/SFresume.html.wml : lib/SFresume_base.wml
	touch $@

t2/SFresume_detailed.html.wml : lib/SFresume_base.wml
	touch $@

$(T2_DEST)/philosophy/Index/index.html : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl

$(T2_DEST)/me/resumes/Shlomi-Fish-Heb-Resume.html: lib/pages/t2/heb_resume.xhtml

T2_DOCS_SRC = $(patsubst $(T2_DEST)/%,$(T2_SRC_DIR)/%.wml,$(T2_DOCS_DEST))

T2_PHILOSOPHY_DOCS = \
	$(filter $(T2_DEST)/philosophy/%,$(T2_DOCS_DEST)) \
	$(filter $(T2_DEST)/prog-evolution/%,$(T2_DOCS_DEST)) \
	$(filter $(T2_DEST)/DeCSS/%,$(T2_DOCS_DEST))

$(T2_PHILOSOPHY_DOCS): %: $(PHILOSOPHY_DEPS)

T2_LECTURES_DOCS_SRC = $(filter $(T2_SRC_DIR)/lecture/%,$(T2_DOCS_SRC))

$(T2_LECTURES_DOCS_SRC): $(T2_SRC_DIR)/lecture/%.wml: $(LECTURES_DEPS)
	touch $@

COMMON_LECTURES_DOCS_SRC = $(patsubst %,common/%.wml,$(filter lecture/%,$(COMMON_DOCS)))

$(COMMON_LECTURES_DOCS_SRC): common/lecture/%.wml: $(LECTURES_DEPS)
	touch $@

T2_SOFTWARE_DOCS_SRC = $(filter $(T2_SRC_DIR)/open-source/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/jmikmod/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/grad-fu/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/no-ie/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/rindolf/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/rwlock/%,$(T2_DOCS_SRC))

$(T2_SOFTWARE_DOCS_SRC): $(T2_SRC_DIR)/%.wml: $(SOFTWARE_DEPS)
	touch $@

#### Humour thing

T2_HUMOUR_DOCS_DEST = $(filter $(T2_DEST)/humour/%,$(T2_DOCS_DEST)) \
					 $(filter $(T2_DEST)/humour.html,$(T2_DOCS_DEST)) \
					 $(filter $(T2_DEST)/humour-heb.html,$(T2_DOCS_DEST)) \
					 $(filter $(T2_DEST)/wysiwyt.html,$(T2_DOCS_DEST)) \
					 $(filter $(T2_DEST)/wonderous.html,$(T2_DOCS_DEST))

$(T2_HUMOUR_DOCS_DEST): $(HUMOUR_DEPS)

T2_ART_DOCS_DEST = $(filter $(T2_DEST)/art/%,$(T2_DOCS_DEST))

$(T2_ART_DOCS_DEST): $(ART_DEPS)

T2_PUZZLES_DOCS_SRC = $(filter $(T2_SRC_DIR)/puzzles/%,$(T2_DOCS_SRC)) $(filter $(T2_SRC_DIR)/MathVentures/%,$(T2_DOCS_SRC)) $(filter $(T2_SRC_DIR)/toggle.html.wml,$(T2_DOCS_SRC))

$(T2_PUZZLES_DOCS_SRC): $(T2_SRC_DIR)/%.wml: $(PUZZLES_DEPS)
	touch $@

T2_META_DOCS_DEST = $(filter $(T2_DEST)/meta/%,$(T2_DOCS_DEST))

$(T2_META_DOCS_DEST): $(META_SUBSECT_DEPS)

$(T2_HUMOUR_DOCS_DEST): $(HUMOUR_DEPS)
rss:
	perl ./bin/fetch-shlomif_hsite-feed.pl
	touch t2/index.html.wml
	touch t2/old-news.html.wml

sitemap_targets: $(T2_SITEMAP_FILE)

PROD_SYND_MUSIC_DIR = lib/prod-synd/music
PROD_SYND_MUSIC_INC = $(PROD_SYND_MUSIC_DIR)/include-me.html

PROD_SYND_NON_FICTION_BOOKS_DIR = lib/prod-synd/non-fiction-books
PROD_SYND_NON_FICTION_BOOKS_INC = $(PROD_SYND_NON_FICTION_BOOKS_DIR)/include-me.html

PROD_SYND_FILMS_DIR = lib/prod-synd/films
PROD_SYND_FILMS_INC = $(PROD_SYND_FILMS_DIR)/include-me.html

$(T2_SRC_DIR)/art/recommendations/music/index.html.wml : $(PROD_SYND_MUSIC_INC)
	touch $@

GPERL = perl -Ilib
GPERL_DEPS = lib/Shlomif/Homepage/Amazon/Obj.pm

$(PROD_SYND_MUSIC_INC) : $(PROD_SYND_MUSIC_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/art/recommendations/music/shlomi-fish-music-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

$(T2_DEST)/philosophy/books-recommends/index.html : $(PROD_SYND_NON_FICTION_BOOKS_INC)

$(PROD_SYND_NON_FICTION_BOOKS_INC) : $(PROD_SYND_NON_FICTION_BOOKS_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/philosophy/books-recommends/shlomi-fish-non-fiction-books-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

$(T2_DEST)/humour/recommendations/films/index.html: $(PROD_SYND_FILMS_INC)

$(PROD_SYND_FILMS_INC) : $(PROD_SYND_FILMS_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/humour/recommendations/films/shlomi-fish-films-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<

$(SITE_SOURCE_INSTALL_TARGET): INSTALL.md
	$(call COPY)

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

FICTION_DOCS = $(FICTION_DOCS_ADDITIONS) $(FICTION_DOCS_FROM_GEN)

DOCBOOK4_INSTALLED_CSS_DIRS = $(foreach dir,$(DOCBOOK4_DIRS_LIST),$(T2_DEST)/$(dir)/docbook-css)
DOCMAKE_STYLE_CSS = $(DOCMAKE_XSLT_PATH)/style.css

DOCBOOK4_BASE_DIR = lib/docbook/4
DOCBOOK4_RENDERED_DIR = $(DOCBOOK4_BASE_DIR)/rendered
DOCBOOK4_ALL_IN_ONE_XHTML_DIR = $(DOCBOOK4_BASE_DIR)/essays

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

DOCBOOK5_BASE_DIR = lib/docbook/5
DOCBOOK5_ALL_IN_ONE_XHTML_DIR = $(DOCBOOK5_BASE_DIR)/essays
DOCBOOK5_SOURCES_DIR = $(DOCBOOK5_BASE_DIR)/xml
DOCBOOK5_EPUB_DIR = $(DOCBOOK5_BASE_DIR)/epub
DOCBOOK5_FO_DIR = $(DOCBOOK5_BASE_DIR)/fo
DOCBOOK5_PDF_DIR = $(DOCBOOK5_BASE_DIR)/pdf
DOCBOOK5_RTF_DIR = $(DOCBOOK5_BASE_DIR)/rtf
DOCBOOK5_FOR_OOO_XHTML_DIR = $(DOCBOOK5_BASE_DIR)/for-ooo-xhtml
DOCBOOK5_RENDERED_DIR = $(DOCBOOK5_BASE_DIR)/rendered

DOCBOOK4_TARGETS = $(patsubst %,$(DOCBOOK4_RENDERED_DIR)/%.html,$(DOCBOOK4_DOCS))
DOCBOOK4_XMLS = $(patsubst %,$(DOCBOOK4_XML_DIR)/%.xml,$(DOCBOOK4_DOCS))

DOCBOOK4_FOS = $(patsubst %,$(DOCBOOK4_FO_DIR)/%.fo,$(DOCBOOK4_DOCS))

DOCBOOK4_PDFS = $(patsubst %,$(DOCBOOK4_PDF_DIR)/%.pdf,$(DOCBOOK4_DOCS))

DOCBOOK4_RTFS = $(patsubst %,$(DOCBOOK4_RTF_DIR)/%.rtf,$(DOCBOOK4_DOCS))

DOCBOOK4_INDIVIDUAL_XHTMLS = $(patsubst %,$(DOCBOOK4_INDIVIDUAL_XHTML_DIR)/%,$(DOCBOOK4_DOCS))

DOCBOOK4_ALL_IN_ONE_XHTMLS = $(patsubst %,$(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html,$(DOCBOOK4_DOCS))

# We have our own style for human-hacking-field-guide so we get rid of it.
DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS = $(patsubst %/all-in-one.html,%/style.css,$(filter-out human-hacking-%,$(DOCBOOK4_ALL_IN_ONE_XHTMLS)))

DOCBOOK5_TARGETS = $(patsubst %,$(DOCBOOK5_RENDERED_DIR)/%.xhtml,$(DOCBOOK5_DOCS))
DOCBOOK5_XMLS = $(patsubst %,$(DOCBOOK5_XML_DIR)/%.xml,$(DOCBOOK5_DOCS))

SCREENPLAY_XMLS = $(patsubst %,$(SCREENPLAY_XML_XML_DIR)/%.xml,$(SCREENPLAY_DOCS))
FICTION_XMLS = $(patsubst %,$(FICTION_XML_XML_DIR)/%.xml,$(FICTION_DOCS))
FICTION_DB5S = $(patsubst %,$(DOCBOOK5_XML_DIR)/%.xml,$(FICTION_DOCS))

DOCBOOK5_EPUBS = $(patsubst %,$(DOCBOOK5_EPUB_DIR)/%.epub,$(filter-out hebrew-html-tutorial ,$(DOCBOOK5_DOCS)))

DOCBOOK5_FOS = $(patsubst %,$(DOCBOOK5_FO_DIR)/%.fo,$(DOCBOOK5_DOCS))

DOCBOOK5_FOR_OOO_XHTMLS = $(patsubst %,$(DOCBOOK5_FOR_OOO_XHTML_DIR)/%.html,$(DOCBOOK5_DOCS))

DOCBOOK5_PDFS = $(patsubst %,$(DOCBOOK5_PDF_DIR)/%.pdf,$(DOCBOOK5_DOCS))

DOCBOOK5_RTFS = $(patsubst %,$(DOCBOOK5_RTF_DIR)/%.rtf,$(DOCBOOK5_DOCS))

DOCBOOK5_INDIVIDUAL_XHTMLS = $(patsubst %,$(DOCBOOK5_INDIVIDUAL_XHTML_DIR)/%,$(DOCBOOK5_DOCS))

DOCBOOK5_ALL_IN_ONE_XHTMLS = $(patsubst %,$(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml,$(DOCBOOK5_DOCS))

all: splay

include lib/make/docbook/sf-homepage-docbooks-generated.mak
include lib/make/docbook/sf-fictions.mak
include lib/make/docbook/sf-screenplays.mak

SCREENPLAY_RENDERED_HTMLS = $(patsubst %,$(SCREENPLAY_XML_RENDERED_HTML_DIR)/%.html,$(SCREENPLAY_DOCS))
SCREENPLAY_XML_HTMLS = $(patsubst %,$(SCREENPLAY_XML_HTML_DIR)/%.html,$(SCREENPLAY_DOCS))
SCREENPLAY_XML_EPUBS = $(patsubst %,$(SCREENPLAY_XML_EPUB_DIR)/%.epub,$(SCREENPLAY_DOCS_FROM_GEN))
SCREENPLAY_XML_FOR_OOO_XHTMLS = $(patsubst %,$(SCREENPLAY_XML_FOR_OOO_XHTML_DIR)/%.xhtml,$(SCREENPLAY_DOCS))

splay: $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_XML_HTMLS) $(SCREENPLAY_XML_EPUBS)

$(SCREENPLAY_XML_HTML_DIR)/%.html: $(SCREENPLAY_XML_XML_DIR)/%.xml
	perl -MXML::Grammar::Screenplay::App::ToHTML -e 'run()' -- \
	-o $@ $<
	perl -lpi -e 's/[ \t]+\z//' $@

$(SCREENPLAY_XML_RENDERED_HTML_DIR)/%.html: $(SCREENPLAY_XML_HTML_DIR)/%.html
	./bin/extract-screenplay-xml-html.pl -o $@ $<

$(SCREENPLAY_XML_FOR_OOO_XHTML_DIR)/%.xhtml: $(SCREENPLAY_XML_HTML_DIR)/%.html
	cat $< | perl -lne 'print unless m{\A<\?xml}' > $@

$(SCREENPLAY_XML_XML_DIR)/%.xml: $(SCREENPLAY_XML_TXT_DIR)/%.txt
	perl -MXML::Grammar::Screenplay::App::FromProto -e 'run()' -- \
	-o $@ $<
	perl -lpi -e 's/[ \t]+\z//' $@

SCREENPLAY_SOURCES_ON_DEST = $(T2_DEST)/humour/TOWTF/TOW_Fountainhead_1.txt $(T2_DEST)/humour/TOWTF/TOW_Fountainhead_2.txt $(T2_DEST)/humour/humanity/Humanity-Movie.txt $(T2_DEST)/humour/humanity/Humanity-Movie-hebrew.txt $(T2_DEST)/humour/Star-Trek/We-the-Living-Dead/star-trek--we-the-living-dead.txt $(T2_DEST)/humour/Selina-Mandrake/selina-mandrake-the-slayer.txt $(T2_DEST)/open-source/interviews/ae-interview.txt $(T2_DEST)/open-source/interviews/sussman-interview.txt $(T2_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-part-1.txt $(T2_DEST)/humour/by-others/hitchhiker-guide-to-star-trek-tng-hand-tweaked.txt $(T2_DEST)/humour/Summerschool-at-the-NSA/summerschool-at-the-nsa.screenplay-text.txt $(T2_DEST)/humour/Buffy/A-Few-Good-Slayers/buffy--a-few-good-slayers.txt $(T2_DEST)/humour/So-Who-The-Hell-Is-Qoheleth/So-Who-The-Hell-Is-Qoheleth.screenplay-text.txt

HHFG_DIR = $(T2_DEST)/humour/human-hacking
HHFG_HEB_V2_TXT = human-hacking-field-guide-hebrew-v2.txt
HHFG_HEB_V2_DEST = $(HHFG_DIR)/$(HHFG_HEB_V2_TXT)
HHFG_HEB_V2_XSLT_DEST = $(HHFG_DIR)/human-hacking-field-guide-hebrew-v2.db-postproc.xslt

FICTION_TEXT_SOURCES_ON_DEST = $(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-hebrew.txt $(HHFG_HEB_V2_DEST) $(HHFG_HEB_V2_XSLT_DEST) $(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-english.txt

$(FICTION_DB5S): $(DOCBOOK5_XML_DIR)/%.xml: $(FICTION_XML_XML_DIR)/%.xml
	xslt="$(patsubst $(FICTION_XML_XML_DIR)/%.xml,$(FICTION_XML_DB5_XSLT_DIR)/%.xslt,$<)" ; \
	temp_db5="$(patsubst $(FICTION_XML_XML_DIR)/%.xml,$(FICTION_XML_TEMP_DB5_DIR)/%.xml,$<)" ; \
	if test -e "$$xslt" ; then \
		perl -MXML::Grammar::Fiction::App::ToDocBook -e 'run()' -- \
			-o "$$temp_db5" $< && \
		xsltproc --output "$@" "$$xslt" "$$temp_db5" ; \
	else \
		perl -MXML::Grammar::Fiction::App::ToDocBook -e 'run()' -- \
			-o $@ $< ; \
	fi
	perl -i -lape 's/\s+$$//' $@

$(FICTION_XMLS): $(FICTION_XML_XML_DIR)/%.xml: $(FICTION_XML_TXT_DIR)/%.txt
	perl -MXML::Grammar::Fiction::App::FromProto -e 'run()' -- \
	-o $@ $<
	perl -i -lape 's/\s+$$//' $@

$(DOCBOOK4_RENDERED_DIR)/%.html: $(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html
	./bin/clean-up-docbook-xsl-xhtml.pl -o $@ $<

DOCMAKE_SGML_PATH = lib/sgml/shlomif-docbook
DOCBOOK4_MAK_MAKEFILES_PATH = lib/make/docbook

include $(DOCBOOK4_MAK_MAKEFILES_PATH)/docbook-render.mak

DOCMAKE_PARAMS = -v

HHGG_CONVERT_SCRIPT_FN = convert-hitchhiker-guide-to-st-tng-to-screenplay-xml.pl
HHGG_CONVERT_SCRIPT_SRC = bin/processors/$(HHGG_CONVERT_SCRIPT_FN)
HHGG_CONVERT_SCRIPT_DEST = $(T2_DEST)/humour/by-others/$(HHGG_CONVERT_SCRIPT_FN).txt

$(HHGG_CONVERT_SCRIPT_DEST): $(HHGG_CONVERT_SCRIPT_SRC)
	$(call COPY)

hhgg_convert: $(HHGG_CONVERT_SCRIPT_DEST)

FRON_IMAGE_BASE = fron-demon-illustration-small-indexed.png
SELINA_MANDRAKE_ENG_FRON_IMAGE__SOURCE = $(SELINA_MANDRAKE__VCS_DIR)/graphics/fron/$(FRON_IMAGE_BASE)
SELINA_MANDRAKE_ENG_FRON_IMAGE__DEST = $(T2_DEST)/humour/Selina-Mandrake/images/$(FRON_IMAGE_BASE)

$(SELINA_MANDRAKE_ENG_FRON_IMAGE__DEST): $(SELINA_MANDRAKE_ENG_FRON_IMAGE__SOURCE)
	$(call COPY)

QOHELETH_IMAGES__BASE = sigourney-weaver--resized.jpg summer-glau--two-guns--400w.jpg Friends-S02E04--Nothing-Sexier.svg.jpg If-You-Wanna-Be-Sad.svg.jpg

QOHELETH_IMAGES__SOURCE_PREFIX = $(SO_WHO_THE_HELL_IS_QOHELETH__VCS_DIR)/graphics
QOHELETH_IMAGES__DEST_PREFIX = $(T2_DEST)/humour/So-Who-The-Hell-Is-Qoheleth/images

QOHELETH_IMAGES__SOURCE = $(patsubst %,$(QOHELETH_IMAGES__SOURCE_PREFIX)/%,$(QOHELETH_IMAGES__BASE))
QOHELETH_IMAGES__DEST = $(patsubst %,$(QOHELETH_IMAGES__DEST_PREFIX)/%,$(QOHELETH_IMAGES__BASE))

$(QOHELETH_IMAGES__DEST): $(QOHELETH_IMAGES__DEST_PREFIX)/%: $(QOHELETH_IMAGES__SOURCE_PREFIX)/%
	$(call COPY)

$(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng.txt : $(HHGG_CONVERT_SCRIPT_SRC) t2/humour/by-others/hitchhiker-guide-to-star-trek-tng.txt
	perl $<

$(T2_DEST)/humour/by-others/hitchhiker-guide-to-star-trek-tng-hand-tweaked.txt: $(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng-hand-tweaked.txt
	$(call COPY)

$(T2_DEST)/humour/humanity/Humanity-Movie.txt: $(SCREENPLAY_XML_TXT_DIR)/Humanity-Movie.txt
	$(call COPY)

$(T2_DEST)/humour/humanity/Humanity-Movie-hebrew.txt: $(SCREENPLAY_XML_TXT_DIR)/Humanity-Movie-hebrew.txt
	$(call COPY)

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-hebrew.txt: $(FICTION_XML_TXT_DIR)/The-Pope-Died-on-Sunday-hebrew.txt
	$(call COPY)

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-english.txt: $(FICTION_XML_TXT_DIR)/The-Pope-Died-on-Sunday-english.txt
	$(call COPY)

$(HHFG_HEB_V2_DEST): $(FICTION_XML_TXT_DIR)/human-hacking-field-guide-v2--hebrew.txt
	$(call COPY)

$(HHFG_HEB_V2_XSLT_DEST): $(FICTION_XML_DB5_XSLT_DIR)/human-hacking-field-guide-hebrew-v2.xslt
	$(call COPY)

screenplay_epub_dests: $(SCREENPLAY_XML__EPUBS_DESTS)

$(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.html: $(SCREENPLAY_XML_TXT_DIR)/humanity-excerpt-for-X-G-Screenplay-demo.txt
$(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/humanity-excerpt-for-X-G-Screenplay-demo.html
$(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.html: $(FICTION_XML_TXT_DIR)/fiction-text-example-for-X-G-Fiction-demo.txt
$(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.html: $(DOCBOOK5_RENDERED_DIR)/fiction-text-example-for-X-G-Fiction-demo.xhtml

# Rebuild the embedded docbook4 pages in the $(T2_DEST) after they are
# modified.

PUT_CARDS_2013_XHTML = lib/pages/t2/philosophy/putting-all-cards-on-the-table.xhtml
PUT_CARDS_2013_DEST = $(T2_DEST)/philosophy/philosophy/put-cards-2013.xhtml

PUT_CARDS_2013_XHTML_STRIPPED = $(PUT_CARDS_2013_XHTML).processed-stripped

STRIP_HTML_BIN = bin/processors/strip-html-overhead.pl

$(PUT_CARDS_2013_XHTML_STRIPPED): $(PUT_CARDS_2013_XHTML) $(STRIP_HTML_BIN)
	perl $(STRIP_HTML_BIN) < $< > $@

HOW_TO_GET_HELP_2013_XHTML = lib/pages/t2/philosophy/how-to-get-help-online.xhtml
HOW_TO_GET_HELP_2013_XHTML_STRIPPED = $(HOW_TO_GET_HELP_2013_XHTML).processed-stripped

$(HOW_TO_GET_HELP_2013_XHTML_STRIPPED): $(HOW_TO_GET_HELP_2013_XHTML) $(STRIP_HTML_BIN)
	perl $(STRIP_HTML_BIN) < $< > $@

$(T2_DEST)/philosophy/computers/how-to-get-help-online/2013.html: $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)

all: $(PUT_CARDS_2013_DEST) $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)

$(T2_DEST)/humour/TOWTF/TOW_Fountainhead_1.txt $(T2_DEST)/humour/TOWTF/TOW_Fountainhead_2.txt: $(T2_DEST)/humour/TOWTF/%.txt: $(SCREENPLAY_XML_TXT_DIR)/%.txt
	$(call COPY)

$(T2_DEST)/humour/Selina-Mandrake/selina-mandrake-the-slayer.txt: $(T2_DEST)/humour/Selina-Mandrake/%.txt: $(SCREENPLAY_XML_TXT_DIR)/%.txt
	$(call COPY)

$(T2_DEST)/philosophy/philosophy/putting-all-cards-on-the-table-2013/index.html : $(PUT_CARDS_2013_XHTML_STRIPPED)

$(PUT_CARDS_2013_DEST): $(PUT_CARDS_2013_XHTML)
	$(call COPY)

# Rebuild the pages containing the links to t2/humour/stories upon changing
# the lib/stories.

$(T2_DEST)/humour/index.html $(T2_DEST)/humour/stories/index.html $(T2_DEST)/humour/stories/Star-Trek/index.html $(T2_DEST)/humour/stories/Star-Trek/We-the-Living-Dead/index.html $(T2_DEST)/humour/TheEnemy/index.html: lib/stories/stories-list.wml

$(T2_DEST)/humour/humanity/index.html $(T2_DEST)/humour/humanity/ongoing-text.html $(T2_DEST)/humour/humanity/buy-the-fish-in-hebrew.html $(T2_DEST)/humour/humanity/ongoing-text-hebrew.html : lib/stories/blurbs.wml

$(T2_DEST)/links.html $(T2_DEST)/philosophy/computers/web/create-a-great-personal-homesite/index.html $(T2_DEST)/philosophy/computers/web/create-a-great-personal-homesite/rev2.html $(T2_DEST)/humour/by-others/division-two/index.html: lib/div2mag.wml

$(T2_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-part-1.txt: $(SCREENPLAY_XML_TXT_DIR)/Blue-Rabbit-Log-part-1.txt
	$(call COPY)

$(T2_DEST)/humour/Star-Trek/We-the-Living-Dead/star-trek--we-the-living-dead.txt: $(SCREENPLAY_XML_TXT_DIR)/Star-Trek--We-the-Living-Dead.txt
	$(call COPY)

$(T2_DEST)/humour/Summerschool-at-the-NSA/summerschool-at-the-nsa.screenplay-text.txt: $(SCREENPLAY_XML_TXT_DIR)/Summerschool-at-the-NSA.txt
	$(call COPY)

$(T2_DEST)/humour/So-Who-The-Hell-Is-Qoheleth/So-Who-The-Hell-Is-Qoheleth.screenplay-text.txt: $(SCREENPLAY_XML_TXT_DIR)/So-Who-the-Hell-is-Qoheleth.txt
	$(call COPY)

$(T2_DEST)/humour/Buffy/A-Few-Good-Slayers/buffy--a-few-good-slayers.txt: $(SCREENPLAY_XML_TXT_DIR)/Buffy--a-Few-Good-Slayers.txt
	$(call COPY)

$(T2_DEST)/open-source/interviews/ae-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/ae-interview.txt
	$(call COPY)

$(T2_DEST)/open-source/interviews/sussman-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/sussman-interview.txt
	$(call COPY)

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-hebrew.xml: $(DOCBOOK5_XML_DIR)/The-Pope-Died-on-Sunday-hebrew.xml
	$(call COPY)

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-english.xml: $(DOCBOOK5_XML_DIR)/The-Pope-Died-on-Sunday-english.xml
	$(call COPY)

tidy: all
	perl bin/run-tidy.pl

.PHONY: install_docbook4_pdfs install_docbook_xmls install_docbook4_rtfs install_docbook_individual_xhtmls install_docbook_css_dirs make-dirs

# This copies all the .pdf's at once - not ideal, but still
# working.

$(DOCBOOK4_INSTALLED_CSS_DIRS) : lib/sgml/docbook-css/docbook-css-0.4/
	mkdir -p $@
	rsync -r -v $< $@

FORTUNES_XHTMLS_DIR = lib/fortunes/xhtmls

FORTUNES_LIST_PM = lib/Shlomif/Homepage/FortuneCollections.pm
FORTUNES_LIST__DEPS = $(FORTUNES_LIST_PM) lib/Shlomif/fortunes-meta-data.yml

FORTUNES_XMLS_BASE = $(addsuffix .xml,$(FORTUNES_FILES_BASE))
FORTUNES_XMLS_SRC = $(patsubst %,$(T2_FORTUNES_DIR)/%,$(FORTUNES_XMLS_BASE))
FORTUNES_XHTMLS = $(patsubst $(T2_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_XHTMLS_TOCS = $(patsubst $(T2_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.toc-xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_SOURCE_WMLS = $(patsubst %,$(T2_FORTUNES_DIR)/%.html.wml,$(FORTUNES_FILES_BASE))
FORTUNES_DEST_HTMLS = $(patsubst $(T2_FORTUNES_DIR)/%.html.wml,$(T2_DEST_FORTUNES_DIR)/%.html,$(FORTUNES_SOURCE_WMLS))
FORTUNES_XHTMLS__COMPRESSED = $(patsubst %.xhtml,%.compressed.xhtml,$(FORTUNES_XHTMLS))
FORTUNES_XHTMLS__FOR_INPUT_PORTIONS = $(patsubst %.xhtml,%.xhtml-for-input,$(FORTUNES_XHTMLS))
FORTUNES_WMLS_HTMLS = $(patsubst %,$(T2_DEST_FORTUNES_DIR)/%.html,$(FORTUNES_FILES_BASE))
FORTUNES_TEXTS = $(patsubst %.xml,%,$(FORTUNES_XMLS_SRC))
FORTUNES_ATOM_FEED = $(T2_FORTUNES_DIR)/fortunes-shlomif-all.atom
FORTUNES_RSS_FEED = $(T2_FORTUNES_DIR)/fortunes-shlomif-all.rss
FORTUNES_SQLITE_DB = $(T2_FORTUNES_DIR)/fortunes-shlomif-lookup.sqlite3
T2_DEST_HTMLS_FORTUNES = $(patsubst %,$(T2_DEST_FORTUNES_DIR)/%.html,$(FORTUNES_FILES_BASE))

fortunes-compile-xmls: $(FORTUNES_SOURCE_WMLS) $(FORTUNES_XHTMLS) $(FORTUNES_XHTMLS__COMPRESSED) $(FORTUNES_TEXTS) $(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED) $(FORTUNES_SQLITE_DB)

# The touch is to make sure we compile the .html.wml again.

FORTUNES_CONVERT_TO_XHTML_SCRIPT = $(T2_FORTUNES_DIR)/convert-to-xhtml.pl
FORTUNES_PREPARE_FOR_INPUT_SCRIPT = $(T2_FORTUNES_DIR)/prepare-xhtml-for-input.pl

$(FORTUNES_SOURCE_WMLS): $(FORTUNES_LIST__DEPS)
	perl -Ilib -MShlomif::Homepage::FortuneCollections -e 'Shlomif::Homepage::FortuneCollections->print_all_fortunes_html_wmls()'

$(FORTUNES_XHTMLS__FOR_INPUT_PORTIONS): %.xhtml-for-input: %.compressed.xhtml $(FORTUNES_PREPARE_FOR_INPUT_SCRIPT)
	perl $(FORTUNES_PREPARE_FOR_INPUT_SCRIPT) $< $@

$(FORTUNES_XHTMLS): $(FORTUNES_XHTMLS_DIR)/%.xhtml : $(T2_FORTUNES_DIR)/%.xml $(FORTUNES_CONVERT_TO_XHTML_SCRIPT)
	bash $(T2_FORTUNES_DIR)/run-validator.bash $< && \
	perl $(FORTUNES_CONVERT_TO_XHTML_SCRIPT) $< $@

FORTUNES_XML_TO_XHTML_TOC_XSLT = lib/fortunes/fortune-xml-to-xhtml-toc.xslt

$(FORTUNES_XHTMLS_TOCS): $(FORTUNES_XHTMLS_DIR)/%.toc-xhtml : $(T2_FORTUNES_DIR)/%.xml $(FORTUNES_XML_TO_XHTML_TOC_XSLT)
	xsltproc $(FORTUNES_XML_TO_XHTML_TOC_XSLT) $< | \
	perl -0777 -lapE 's#\A.*?<ul[^>]*?>#<ul>#ms; s#^[ \t]+##gms; s#[ \t]+$$##gms' - > \
	$@

$(FORTUNES_WMLS_HTMLS): $(T2_DEST_FORTUNES_DIR)/%.html: $(FORTUNES_XHTMLS_DIR)/%.xhtml-for-input

FORTUNES_TIDY = tidyp -asxhtml -utf8 -quiet

$(FORTUNES_XHTMLS__COMPRESSED): %.compressed.xhtml: %.xhtml
	$(FORTUNES_TIDY) --show-warnings no -o $@ $< || true

$(T2_FORTUNES_ALL__HTML): $(T2_FORTUNES_ALL__TEMP__HTML) $(FORTUNES_WMLS_HTMLS)
	rm -f $@
	for f in $(T2_DEST_HTMLS_FORTUNES) ; do \
		$(FORTUNES_TIDY) -o "$$f".xhtml "$$f"; \
		mv -f "$$f.xhtml" "$$f"; \
	done
	NO_I=1 $(PROCESS_ALL_INCLUDES) $(T2_DEST_HTMLS_FORTUNES)
	$(FORTUNES_TIDY) -o $@ $<
	NO_I=1 $(PROCESS_ALL_INCLUDES) $@

$(FORTUNES_TEXTS): $(T2_FORTUNES_DIR)/%: $(T2_FORTUNES_DIR)/%.xml
	bash $(T2_FORTUNES_DIR)/run-validator.bash $< && \
	perl $(T2_FORTUNES_DIR)/convert-to-plaintext.pl $< $@

$(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED): $(T2_FORTUNES_DIR)/generate-web-feeds.pl $(FORTUNES_XMLS_SRC)
	perl $< --atom $(FORTUNES_ATOM_FEED) --rss $(FORTUNES_RSS_FEED) --dir $(T2_FORTUNES_DIR)

$(FORTUNES_SQLITE_DB): $(T2_FORTUNES_DIR)/populate-sqlite-database.pl $(FORTUNES_XHTMLS__COMPRESSED) $(FORTUNES_LIST__DEPS)
	perl -Ilib $<

$(FORTUNES_TARGET): $(T2_FORTUNES_DIR)/index.html.wml $(DOCS_COMMON_DEPS) $(HUMOUR_DEPS) $(T2_FORTUNES_DIR)/Makefile $(T2_FORTUNES_DIR)/ver.txt

FORTUNES_PROCESS_ALL_INCLUDES = F=1 $(PROCESS_ALL_INCLUDES)

define FORTUNES_WML_RENDER
$(call GENERIC_GENERIC_WML_RENDER,t2,$(T2_SRC_DIR),$(T2_DEST),$(FORTUNES_PROCESS_ALL_INCLUDES))
endef

# TODO : extract a macro for this and the rule below.
$(FORTUNES_DEST_HTMLS): $(T2_DEST_FORTUNES_DIR)/%.html: $(T2_FORTUNES_DIR)/%.html.wml lib/fortunes/xhtmls/%.toc-xhtml lib/fortunes/xhtmls/%.xhtml $(DOCS_COMMON_DEPS)
	$(call FORTUNES_WML_RENDER)

$(T2_FORTUNES_ALL__TEMP__HTML): $(T2_FORTUNES_ALL_WML) $(DOCS_COMMON_DEPS) $(FORTUNES_XHTMLS__FOR_INPUT_PORTIONS) $(FORTUNES_XHTMLS_TOCS)
	$(call FORTUNES_WML_RENDER)

$(T2_DEST)/humour/fortunes/index.html: $(FORTUNES_LIST__DEPS)

FORTS_EPUB_COVER = $(FORTUNES_XHTMLS_DIR)/shlomif-fortunes.jpg
FORTS_EPUB_SVG   = $(FORTUNES_XHTMLS_DIR)/shlomif-fortunes.svg

FORTS_EPUB_BASENAME = fortunes-shlomif.epub
FORTS_EPUB_DEST = $(T2_DEST_FORTUNES_DIR)/$(FORTS_EPUB_BASENAME)
FORTS_EPUB_SRC = $(FORTUNES_XHTMLS_DIR)/$(FORTS_EPUB_BASENAME)

$(FORTS_EPUB_SRC): fortunes-target
	cd $(FORTUNES_XHTMLS_DIR) && ebookmaker --output $(FORTS_EPUB_BASENAME) book.json

$(FORTS_EPUB_DEST): $(FORTS_EPUB_SRC)
	$(call COPY)

fortunes-epub: $(FORTS_EPUB_DEST)

fortunes-target: $(FORTUNES_TARGET) fortunes-compile-xmls $(T2_DEST_SHOW_CGI) $(T2_DEST_FORTUNE_SHOW_SCRIPT_TXT) $(FORTUNES_DEST_HTMLS) $(T2_FORTUNES_ALL__HTML) $(FORTS_EPUB_COVER)

$(FORTS_EPUB_COVER): $(FORTS_EPUB_SVG)
	inkscape --export-width=600 --export-png="$@" $< && \
	optipng "$@"

$(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS_CSS): %: $(DOCMAKE_STYLE_CSS)
	$(call COPY)

$(DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS): %/style.css: $(DOCMAKE_STYLE_CSS) %/all-in-one.html
	$(call COPY)

MOJOLICIOUS_LECTURE_SLIDE1 = $(T2_DEST)/lecture/Perl/Lightning/Mojolicious/mojolicious-slides.html

HACKING_DOC = $(T2_DEST)/open-source/resources/how-to-contribute-to-my-projects/HACKING.html

mojo_pres: $(MOJOLICIOUS_LECTURE_SLIDE1) $(HACKING_DOC)

$(MOJOLICIOUS_LECTURE_SLIDE1): t2/lecture/Perl/Lightning/Mojolicious/mojolicious.asciidoc.txt
	asciidoc -a linkcss -o $@ $<

$(DOCBOOK4_BASE_DIR)/xml/Spark-Pre-Birth-of-a-Modern-Lisp.xml: t2/open-source/projects/Spark/mission/Spark-Pre-Birth-of-a-Modern-Lisp.txt
	asciidoc --backend=docbook -o $@ $<

$(HACKING_DOC): t2/open-source/resources/how-to-contribute-to-my-projects/HACKING.txt
	asciidoc -a linkcss -o $@ $<

t2/humour/TheEnemy/The-Enemy-rev5.html.wml: lib/htmls/The-Enemy-rev5.html-part

lib/htmls/The-Enemy-rev5.html-part: t2/humour/TheEnemy/The-Enemy-Hebrew-rev5.xhtml.gz ./bin/extract-xhtml.pl
	gunzip < $< | perl ./bin/extract-xhtml.pl -o $@ -

t2/humour/TheEnemy/The-Enemy-English-rev5.html.wml: lib/htmls/The-Enemy-English-rev5.html-part

lib/htmls/The-Enemy-English-rev5.html-part: t2/humour/TheEnemy/The-Enemy-English-rev5.xhtml.gz ./bin/extract-xhtml.pl
	gunzip < $< | perl ./bin/extract-xhtml.pl -o $@ -

t2/humour/TheEnemy/The-Enemy-English-rev6.html.wml: lib/htmls/The-Enemy-English-rev6.html-part

lib/htmls/The-Enemy-English-rev6.html-part: t2/humour/TheEnemy/The-Enemy-English-rev6.xhtml.gz ./bin/extract-xhtml.pl
	gunzip < $< | perl ./bin/extract-xhtml.pl -o $@ -

DOCBOOK4_HHFG_IMAGES_RAW = \
	background-image.png \
	background-shlomif.png \
	bottom-shlomif.png \
	hhfg-bg-bottom.png \
	hhfg-bg-middle.png \
	hhfg-bg-top.png \
	style.css \
	top-shlomif.png

DOCBOOK4_HHFG_DEST_DIR = $(T2_DEST)/humour/human-hacking/human-hacking-field-guide
DOCBOOK4_HHFG_IMAGES_DEST = $(patsubst %,$(DOCBOOK4_HHFG_DEST_DIR)/%,$(DOCBOOK4_HHFG_IMAGES_RAW))

HHFG_V2_IMAGES_DEST_DIR_FROM_VCS = $(T2_DEST)/humour/human-hacking/human-hacking-field-guide-v2--english
HHFG_V2_IMAGES_DEST_DIR = $(T2_DEST)/humour/human-hacking/human-hacking-field-guide-v2
HHFG_V2_IMAGES_DEST = $(patsubst %,$(HHFG_V2_IMAGES_DEST_DIR)/%,$(DOCBOOK4_HHFG_IMAGES_RAW))
HHFG_V2_IMAGES_DEST_FROM_VCS = $(patsubst %,$(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/%,$(DOCBOOK4_HHFG_IMAGES_RAW))

docbook_hhfg_images: $(DOCBOOK4_HHFG_IMAGES_DEST) $(HHFG_V2_IMAGES_DEST) $(HHFG_V2_IMAGES_DEST_FROM_VCS)

$(DOCBOOK4_HHFG_IMAGES_DEST): $(DOCBOOK4_HHFG_DEST_DIR)/%: $(DOCBOOK4_BASE_DIR)/style/human-hacking-field-guide/% $(DOCBOOK4_HHFG_DEST_DIR)/index.html
	$(call COPY)

$(HHFG_V2_IMAGES_DEST_DIR)/index.html: $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/index.html
	mkdir -p $(HHFG_V2_IMAGES_DEST_DIR)
	cp -a $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/*.html $(HHFG_V2_IMAGES_DEST_DIR)/

$(HHFG_V2_IMAGES_DEST): $(HHFG_V2_IMAGES_DEST_DIR)/%: $(DOCBOOK4_BASE_DIR)/style/human-hacking-field-guide/% $(HHFG_V2_IMAGES_DEST_DIR)/index.html
	$(call COPY)

$(HHFG_V2_IMAGES_DEST_FROM_VCS): $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/%: $(DOCBOOK4_BASE_DIR)/style/human-hacking-field-guide/% $(HHFG_V2_IMAGES_DEST_DIR)/index.html
	$(call COPY)

DOCBOOK5_XSL_STYLESHEETS_PATH := /usr/share/sgml/docbook/xsl-ns-stylesheets

DOCBOOK5_XSL_STYLESHEETS_XHTML_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/xhtml-1_1
DOCBOOK5_XSL_STYLESHEETS_ONECHUNK_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/onechunk
DOCBOOK5_XSL_STYLESHEETS_FO_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/fo

DOCBOOK5_XSL_CUSTOM_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-xhtml.xsl
DOCBOOK5_XSL_ONECHUNK_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-xhtml-onechunk.xsl
DOCBOOK5_XSL_FO_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-fo.xsl

DOCBOOK5_DOCS += $(FICTION_DOCS)

# DOCBOOK4_BASE_DIR = lib/docbook/4
# DOCBOOK4_ALL_IN_ONE_XHTML_DIR = $(DOCBOOK4_BASE_DIR)/essays
# DOCBOOK4_SOURCES_DIR = $(DOCBOOK4_BASE_DIR)/xml
# DOCBOOK4_FO_DIR = $(DOCBOOK4_BASE_DIR)/fo
# DOCBOOK4_PDF_DIR = $(DOCBOOK4_BASE_DIR)/pdf
# DOCBOOK4_RENDERED_DIR = $(DOCBOOK4_BASE_DIR)/rendered

# DOCBOOK5_ALL_IN_ONE_XHTMLS = $(patsubst %,$(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml,$(DOCBOOK5_DOCS))
# DOCBOOK5_RENDERED_HTMLS = $(patsubst %,$(DOCBOOK5_RENDERED_DIR)/%.xhtml,$(DOCBOOK5_DOCS))
# DOCBOOK5_FOS = $(patsubst %,$(DOCBOOK5_FO_DIR)/%.fo,$(DOCBOOK5_DOCS))
# DOCBOOK5_PDFS = $(patsubst %,$(DOCBOOK5_PDF_DIR)/%.pdf,$(DOCBOOK5_DOCS))
# DOCBOOK5_RTFS = $(patsubst %,$(DOCBOOK5_RTF_DIR)/%.pdf,$(DOCBOOK5_DOCS))

$(DOCBOOK4_RENDERED_DIR)/%.html: $(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html
	./bin/clean-up-docbook-xsl-xhtml.pl -o $@ $<

$(DOCBOOK4_FO_DIR)/%.fo: $(DOCBOOK4_XML_DIR)/%.xml
	$(DOCMAKE_WITH_PARAMS) -o $@ --stringparam "docmake.output.format=fo" -x $(FO_XSLT_SS) fo $<
	perl -lpi -e 's/[ \t]+\z//' $@

$(DOCBOOK4_PDF_DIR)/%.pdf: $(DOCBOOK4_FO_DIR)/%.fo
	fop -fo $< -pdf $@

$(DOCBOOK4_RTF_DIR)/%.rtf: $(DOCBOOK4_FO_DIR)/%.fo
	fop -fo $< -rtf $@

$(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html: $(DOCBOOK4_XML_DIR)/%.xml
	$(DOCMAKE) --stringparam "docmake.output.format=xhtml" -x $(XHTML_ONE_CHUNK_XSLT_SS) -o $(patsubst $(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html,$(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%,$@) xhtml $<
	mv $(patsubst %/all-in-one.html,%/index.html,$@) $@
	perl -lpi -e 's/[ \t]+\z//' $@

# DOCBOOK5_RELAXNG = http://www.docbook.org/xml/5.0/rng/docbook.rng
DOCBOOK5_RELAXNG = lib/sgml/relax-ng/docbook.rng

$(DOCBOOK5_ALL_IN_ONE_XHTMLS): $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml: $(DOCBOOK5_SOURCES_DIR)/%.xml
	# jing $(DOCBOOK5_RELAXNG) $<
	$(DOCMAKE) --stringparam "root.filename=$@.temp.xml" --basepath $(DOCBOOK5_XSL_STYLESHEETS_PATH) -x $(DOCBOOK5_XSL_ONECHUNK_XSLT_STYLESHEET) xhtml-1_1 $<
	xsltproc --output $@ ./bin/clean-up-docbook-xhtml-1.1.xslt $@.temp.xml.html
	rm -f $@.temp.xml.html
	perl -I./lib -MShlomif::DocBookClean -lpi -0777 -e 's/[ \t]+$$//gms; Shlomif::DocBookClean::cleanup_docbook(\$$_);' $@

$(DOCBOOK5_RENDERED_DIR)/%.xhtml: $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml
	./bin/clean-up-docbook-5-xsl-xhtml-1_1.pl -o $@ $<

$(DOCBOOK5_FO_DIR)/%.fo: $(DOCBOOK5_SOURCES_DIR)/%.xml
	$(DOCMAKE_WITH_PARAMS) --basepath $(DOCBOOK5_XSL_STYLESHEETS_PATH) -o $@ -x $(DOCBOOK5_XSL_FO_XSLT_STYLESHEET) fo $<
	perl -lpi -e 's/[ \t]+\z//' $@

C_BAD_ELEMS_SRC = lib/c-begin/C-and-CPP-elements-to-avoid/c-and-cpp-elements-to-avoid.xml-grammar-vered.xml
DEST__C_BAD_ELEMS_SRC = dest/t2/lecture/C-and-CPP/bad-elements/c-and-cpp-elements-to-avoid.xml-grammar-vered.xml

$(DOCBOOK5_SOURCES_DIR)/c-and-cpp-elements-to-avoid.xml: $(C_BAD_ELEMS_SRC)
	./bin/translate-Vered-XML --output "$@" "$<"

$(DEST__C_BAD_ELEMS_SRC): $(C_BAD_ELEMS_SRC)
	$(call COPY)

all: $(DEST__C_BAD_ELEMS_SRC)

$(DOCBOOK5_PDF_DIR)/%.pdf: $(DOCBOOK5_FO_DIR)/%.fo
	fop -fo $< -pdf $@

EPUB_SCRIPT = $(DOCBOOK5_XSL_STYLESHEETS_PATH)/epub/bin/dbtoepub
EPUB_XSLT = lib/sgml/shlomif-docbook/docbook-epub-preproc.xslt
DBTOEPUB = ruby $(EPUB_SCRIPT)

$(DOCBOOK5_EPUBS): $(DOCBOOK5_EPUB_DIR)/%.epub: $(DOCBOOK5_XML_DIR)/%.xml
	$(DBTOEPUB) -s $(EPUB_XSLT) -o $@ $<

$(DOCBOOK5_RTF_DIR)/%.rtf: $(DOCBOOK5_FO_DIR)/%.fo
	fop -fo $< -rtf $@

$(DOCBOOK5_FOR_OOO_XHTML_DIR)/%.html: $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml
	cat $< | perl -lne 's{(</title>)}{$${1}<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />}; print unless m{\A<\?xml}' > $@

ART_SLOGANS_DOCS = \
	chromaticd/kiss-me-my-blog-post-got-chormaticd \
	CPP-supports-OOP/CPP-supports-OOP-as-much-as \
	dont-believe-in-fairies/dont-believe-in-fairies  \
	give-me-ascii/give-me-ASCII-or-give-me-death \
	lottery-all-you-need-is-a-dollar/lottery-all-you-need-is-a-dollar \
	what-do-you-mean-by-wdym/what-do-you-mean-by-wdym \

ART_SLOGANS_PATHS = $(patsubst %,$(T2_DEST)/art/slogans/%,$(ART_SLOGANS_DOCS))
ART_SLOGANS_PNGS = $(patsubst %,%.png,$(ART_SLOGANS_PATHS))
ART_SLOGANS_THUMBS = $(patsubst %,%.thumb.png,$(ART_SLOGANS_PATHS))

OPTIPNG = optipng -o7

define EXPORT_INKSCAPE_PNG
	inkscape --export-width=200 --export-png="$@" $<
	$(OPTIPNG) $@
endef

include lib/make/long_sories.mak

PRINTER_ICON_PNG = $(T2_DEST)/images/printer_icon.png
TWITTER_ICON_20_PNG = $(T2_DEST)/images/twitter-bird-light-bgs-20.png
HHFG_SMALL_BANNER_AD_PNG = $(T2_DEST)/humour/human-hacking/images/hhfg-ad-468x60.svg.preview.png

BK2HP_NEW_PNG = common/images/bk2hp.png

DEST_HTML_6_LOGO_PNG = $(T2_DEST)/humour/bits/HTML-6/HTML-6-logo.png

$(BK2HP_NEW_PNG): lib/images/back_to_my_homepage_from_inkscape.png
	convert -matte -bordercolor none -border 5 $< $@
	$(OPTIPNG) $@

art_slogans_targets: $(ART_SLOGANS_THUMBS) $(BUFFY_A_FEW_GOOD_SLAYERS__SMALL_LOGO_PNG) $(THE_ENEMY_SMALL_LOGO_PNG) $(HHFG_SMALL_BANNER_AD_PNG) $(PRINTER_ICON_PNG) $(TWITTER_ICON_20_PNG) $(BK2HP_NEW_PNG) $(DEST_HTML_6_LOGO_PNG)

$(DEST_HTML_6_LOGO_PNG): t2/humour/bits/HTML-6/HTML-6-logo.svg
	inkscape --export-dpi=60 --export-area-page --export-png="$@" "$<"
	$(OPTIPNG) $@

DEST_WINDOWS_UPDATE_SNAIL_ICON = $(T2_DEST)/humour/bits/facts/images/windows-update-snail.png

all: $(DEST_WINDOWS_UPDATE_SNAIL_ICON)

$(DEST_WINDOWS_UPDATE_SNAIL_ICON): t2/humour/bits/facts/images/snail.svg
	inkscape --export-width=200 --export-png="$@" $<
	$(OPTIPNG) $@

$(ART_SLOGANS_PNGS): %.png: %.svg
	inkscape --export-png=$@ $<
	$(OPTIPNG) $@

$(ART_SLOGANS_THUMBS): %.thumb.png: %.png
	convert -resize '200' $< $@
	$(OPTIPNG) $@

$(PRINTER_ICON_PNG): common/images/printer_icon.svg
	inkscape --export-width=30 --export-png="$@" $<
	$(OPTIPNG) $@

$(TWITTER_ICON_20_PNG): common/images/twitter-bird-light-bgs.svg
	inkscape --export-width=30 --export-png="$@" $<
	$(OPTIPNG) $@

$(HHFG_SMALL_BANNER_AD_PNG): $(T2_SRC_DIR)/humour/human-hacking/images/hhfg-ad-468x60.svg.png
	convert -resize '50%' $< $@
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
$(LC_PRES_DEST_HTMLS): $(T2_DEST)/%.scm.html: t2/%.scm
	text-vimcolor --format html --full-page $< --output $@
	perl -i -lapE 's#^( *)<style>$$#$$1<style type="text/css">#ms' $@

SPORK_LECTURES_BASENAMES = \
	Perl/Graham-Function \
	Perl/Lightning/Opt-Multi-Task-in-PDL \
	Perl/Lightning/Test-Run \
	Perl/Lightning/Too-Many-Ways \
	SCM/subversion/for-pythoneers \
	Vim/beginners \

SPORK_LECTS_SOURCE_BASE = lib/presentations/spork
GFUNC_PRES_BASE = $(SPORK_LECTS_SOURCE_BASE)/Perl/Graham-Function
GFUNC_PRES_DEST = $(T2_DEST)/lecture/Perl/Graham-Function
GFUNC_PRES_BASE_START = $(GFUNC_PRES_BASE)/slides/start.html
GFUNC_PRES_DEST_START = $(GFUNC_PRES_DEST)/slides/start.html

SPORK_LECTURES_DESTS = $(patsubst %,$(T2_DEST)/lecture/%,$(SPORK_LECTURES_BASENAMES))
SPORK_LECTURES_DEST_STARTS = $(patsubst %,%/slides/start.html,$(SPORK_LECTURES_DESTS))
SPORK_LECTURES_BASE_STARTS = $(patsubst %,$(SPORK_LECTS_SOURCE_BASE)/%/slides/start.html,$(SPORK_LECTURES_BASENAMES))

graham_func_pres_targets: $(SPORK_LECTURES_DEST_STARTS)

$(SPORK_LECTURES_DEST_STARTS) : $(T2_DEST)/lecture/%/start.html: $(SPORK_LECTS_SOURCE_BASE)/%/start.html
	rsync -a $(patsubst %/start.html,%/,$<) $(patsubst %/start.html,%/,$@)

$(SPORK_LECTURES_BASE_STARTS) : $(SPORK_LECTS_SOURCE_BASE)/%/slides/start.html : $(SPORK_LECTS_SOURCE_BASE)/%/Spork.slides $(SPORK_LECTS_SOURCE_BASE)/%/config.yaml
	dn="$(patsubst %/slides/start.html,%,$@)" ; \
		(cd "$$dn" && shspork -make) && perl bin/fix-spork.pl "$$dn"/*.html && \
		(find "$$dn"/template -name '*.js' -or -name '*.html' | xargs perl -lpi -e 's/[\t ]+\z//') \
	cp -f common/favicon.png $(patsubst %/start.html,%,$@)/ || true

lib/presentations/spork/Vim/beginners/Spork.slides: lib/presentations/spork/Vim/beginners/Spork.slides.source
	cat $< | perl -pe 's!^\+!!' > $@

GEN_STYLE_CSS_FILES = style.css style-2008.css fortunes.css fortunes_show.css fort_total.css style-404.css screenplay.css jqui-override.css print.css

T2_CSS_TARGETS = $(patsubst %,$(T2_DEST)/%,$(GEN_STYLE_CSS_FILES))

css_targets: $(T2_CSS_TARGETS) $(T2_DEST)/screenplay.css

SASS_STYLE = compressed
# SASS_STYLE = expanded
SASS_CMD = sass --style $(SASS_STYLE)

$(T2_CSS_TARGETS): $(T2_DEST)/%.css: lib/sass/%.sass
	$(SASS_CMD) $< $@

FORT_SASS_DEPS = lib/sass/fortunes.sass
COMMON_SASS_DEPS = lib/sass/common-body.sass

$(T2_DEST)/style.css $(T2_DEST)/style-2008.css $(T2_DEST)/print.css: lib/sass/common-style.sass $(COMMON_SASS_DEPS) lib/sass/lang_switch.sass $(FORT_SASS_DEPS) lib/sass/code_block.sass lib/sass/jqtree.sass lib/sass/treeview.sass lib/sass/common-with-print.sass lib/sass/self_link.sass

$(T2_DEST)/style.css: lib/sass/smoked-wp-theme.sass lib/sass/footer.sass

$(T2_DEST)/fortunes_show.css: $(COMMON_SASS_DEPS)

$(T2_DEST)/fort_total.css: $(FORT_SASS_DEPS) lib/sass/fortunes.sass lib/sass/fortunes_show.sass $(COMMON_SASS_DEPS) lib/sass/screenplay.sass

$(T2_DEST)/personal.html $(T2_DEST)/personal-heb.html: lib/pages/t2/personal.wml
$(T2_DEST)/humour.html $(T2_DEST)/humour-heb.html: lib/pages/t2/humour.wml
$(T2_DEST)/work/hire-me/index.html $(T2_DEST)/work/hire-me/hebrew.html: lib/pages/t2/hire-me.wml

$(T2_DEST)/open-source/projects/Module-Format/index.html $(T2_DEST)/open-source/projects/File-Find-Object/index.html $(T2_DEST)/open-source/projects/File-Dir-Dumper/index.html $(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.html $(T2_DEST)/open-source/projects/black-hole-solitaire-solver/index.html $(T2_DEST)/open-source/projects/japanese-puzzle-games/abc-path/index.html $(T2_DEST)/meta/FAQ/index.html $(T2_DEST)/open-source/contributions/index.html: lib/Inc/cpan_dists.wml

docbook_extended: $(DOCBOOK4_FOS) $(DOCBOOK4_PDFS) \
	$(DOCBOOK5_FOS) $(DOCBOOK5_PDFS) \
	install_docbook4_pdfs install_docbook4_rtfs \
	install_docbook5_pdfs install_docbook5_rtfs

docbook_indiv: $(DOCBOOK4_INDIVIDUAL_XHTMLS)

docbook_targets: docbook4_targets docbook5_targets screenplay_targets \
	install_docbook5_epubs \
	install_docbook5_htmls \
	install_docbook4_xmls install_docbook_individual_xhtmls \
	install_docbook_css_dirs docbook_hhfg_images install_docbook5_xmls \
	pope_fiction selina_mandrake hhfg_fiction \

docbook4_targets: $(DOCBOOK4_TARGETS) $(DOCBOOK4_ALL_IN_ONE_XHTMLS) $(DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS)

docbook5_targets: $(DOCBOOK5_TARGETS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS_CSS) $(DOCBOOK5_RENDERED_HTMLS) $(DOCBOOK5_FOS) $(DOCBOOK5_FOR_OOO_XHTMLS)

$(T2_DEST)/lecture/Perl/Newbies/lecture5-heb-notes.html: $(T2_SRC_DIR)/lecture/Perl/Newbies/lecture5-notes.txt bin/lecture5-txt2html.bash

$(T2_DEST)/philosophy/by-others/perlcast-transcript--tom-limoncelli-interview/index.html: lib/htmls/from-mediawiki/processed/Perlcast_Transcript_-_Interview_with_Tom_Limoncelli.html

HTML_TUT_BASE = lib/presentations/docbook/html-tutorial/hebrew-html-tutorial

HTML_TUT_HEB_DIR = $(HTML_TUT_BASE)/hebrew-html-tutorial
HTML_TUT_HEB_DB = $(HTML_TUT_BASE)/hebrew-html-tutorial.xml
HTML_TUT_HEB_TT = $(HTML_TUT_BASE)/hebrew-html-tutorial.xml.tt
DEST_HTML_TUT_BASE = $(T2_DEST)/lecture/HTML-Tutorial/v1/xhtml1/hebrew
DEST_HTML_TUT = $(DEST_HTML_TUT_BASE)/index.html

$(DOCBOOK5_SOURCES_DIR)/hebrew-html-tutorial.xml: $(HTML_TUT_HEB_DB)
	$(call COPY)

selina_mandrake: $(SELINA_MANDRAKE_ENG_SCREENPLAY_XML_SOURCE) $(SELINA_MANDRAKE_ENG_TXT_FROM_VCS) $(SELINA_MANDRAKE_ENG_FRON_IMAGE__DEST) $(QOHELETH_IMAGES__DEST)

pope_fiction: $(POPE_ENG_FICTION_XML_SOURCE)

hhfg_fiction: $(HHFG_ENG_DOCBOOK5_SOURCE) $(HHFG_HEB_FICTION_XML_SOURCE)

screenplay_targets: $(ST_WTLD_TEXT_IN_TREE) $(SCREENPLAY_XMLS) $(SCREENPLAY_HTMLS) $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_SOURCES_ON_DEST) $(FICTION_TEXT_SOURCES_ON_DEST) $(SCREENPLAY_XML_FOR_OOO_XHTMLS) $(SELINA_MANDRAKE_ENG_SCREENPLAY_XML_SOURCE) $(SUMMERSCHOOL_AT_THE_NSA_ENG_SCREENPLAY_XML_SOURCE) screenplay_epub_dests

$(DEST_HTML_TUT): $(HTML_TUT_HEB_HTML)
	mkdir -p $(DEST_HTML_TUT_BASE)
	rsync -r $(HTML_TUT_HEB_DIR)/ $(DEST_HTML_TUT_BASE)

$(HTML_TUT_HEB_DB): $(HTML_TUT_HEB_TT)
	cd $(HTML_TUT_BASE) && make docbook

$(HTML_TUT_HEB_TT):
	cd lib/presentations/docbook && hg clone https://shlomif@bitbucket.org/shlomif/html-tutorial

update_html_tut: update_html_tut_hg html_tutorial

update_html_tut_hg:
	cd $(HTML_TUT_BASE) && (hg pull ; hg update)

include deps.mak

MATHJAX_DEST_DIR = $(T2_DEST)/js/MathJax
MATHJAX_DEST_README = $(MATHJAX_DEST_DIR)/README.md

mathjax_dest: make-dirs $(MATHJAX_DEST_README)

$(MATHJAX_DEST_README): $(MATHJAX_SOURCE_README)
	rsync -r -v --progress lib/MathJax/ $(T2_DEST)/js/MathJax/
	rm -fr $(MATHJAX_DEST_DIR)/.git
	rm -fr $(MATHJAX_DEST_DIR)/.gitignore
	rm -fr $(MATHJAX_DEST_DIR)/test

SCRIPTS_WITH_OFFENDING_EXTENSIONS = t2/MathVentures/gen-bugs-in-square-svg.pl t2/open-source/bits-and-bobs/nowplay-xchat.pl t2/open-source/bits-and-bobs/pmwiki-revert.pl t2/open-source/bits-and-bobs/convert-kabc-dist-lists.pl

SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS = $(patsubst $(T2_SRC_DIR)/%.pl,$(T2_DEST)/%-pl.txt,$(SCRIPTS_WITH_OFFENDING_EXTENSIONS))

plaintext_scripts_with_offending_extensions: $(SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS)

$(SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS): $(T2_DEST)/%-pl.txt: $(T2_SRC_DIR)/%.pl
	$(call COPY)

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
	perl $< $(T2_DEST_IMAGES_DIR)

NAV_DATA_AS_JSON = $(T2_DEST)/_data/nav.json

generate_nav_data_as_json: $(NAV_DATA_AS_JSON)

$(NAV_DATA_AS_JSON): $(NAV_DATA_DEP) $(NAV_DATA_AS_JSON_BIN) lib/Shlomif/Homepage/NavData/JSON.pm $(ALL_SUBSECTS_DEPS)
	./$(NAV_DATA_AS_JSON_BIN) -o $@

$(T2_DEST)/site-map/index.html: $(ALL_SUBSECTS_DEPS)

generate_nav_data_as_json:

JQTREE_SRC = common/js/tree.jquery.js
JQTREE_MIN_DEST = $(T2_DEST)/js/tree.jq.js
MAIN_TOTAL_MIN_JS_DEST = $(T2_DEST)/js/main_all.js

MULTI_YUI = ./bin/Run-YUI-Compressor

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
	common/js/print-ver.js \

$(JQTREE_MIN_DEST): $(JQTREE_SRC) $(MULTI_YUI)
	$(MULTI_YUI) -o $@ $(JQTREE_SRC)

minified_javascripts: $(JQTREE_MIN_DEST) $(MAIN_TOTAL_MIN_JS_DEST)

$(MAIN_TOTAL_MIN_JS_DEST): $(MULTI_YUI) $(MAIN_TOTAL_MIN_JS__SOURCES)
	$(MULTI_YUI) -o $@ $(MAIN_TOTAL_MIN_JS__SOURCES)

PRINTABLE_RESUMES__HTML__PIVOT = printable/Shlomi-Fish-English-Resume-Detailed.html
PRINTABLE_RESUMES__HTML = $(PRINTABLE_RESUMES__HTML__PIVOT) printable/Shlomi-Fish-English-Resume.html printable/Shlomi-Fish-Heb-Resume.html printable/Shlomi-Fish-Resume-as-Software-Dev.html


printable_resumes__html : $(PRINTABLE_RESUMES__HTML__PIVOT)

PRINTABLE_RESUMES__DOCX = $(patsubst %.html,%.docx,$(PRINTABLE_RESUMES__HTML))

$(PRINTABLE_RESUMES__DOCX): %.docx: %.html
	libreoffice --headless -convert-to docx --outdir printable $<

$(PRINTABLE_RESUMES__HTML__PIVOT): $(T2_DEST)/SFresume.html $(T2_DEST)/SFresume_detailed.html $(T2_DEST)/me/resumes/Shlomi-Fish-Heb-Resume.html $(T2_DEST)/me/resumes/Shlomi-Fish-Resume-as-Software-Dev.html
	bash bin/gen-printable-CVs.sh
	perl -lp -0777 -e 's#\A<\?xml ver.*?\?>##' < $(T2_DEST)/me/resumes/Shlomi-Fish-Heb-Resume.html > printable/Shlomi-Fish-Heb-Resume.html
	cp -f printable/SFresume.html printable/Shlomi-Fish-English-Resume.html
	cp -f printable/SFresume_detailed.html printable/Shlomi-Fish-English-Resume-Detailed.html

resumes: $(PRINTABLE_RESUMES__DOCX)

install_docbook5_epubs: make-dirs $(DOCBOOK5_INSTALLED_EPUBS)
install_docbook5_htmls: make-dirs $(DOCBOOK5_INSTALLED_HTMLS)

install_docbook4_pdfs: make-dirs $(DOCBOOK4_INSTALLED_PDFS)
install_docbook5_pdfs: make-dirs $(DOCBOOK5_INSTALLED_PDFS)

install_docbook4_xmls: make-dirs $(DOCBOOK4_INSTALLED_XMLS)
install_docbook5_xmls: make-dirs $(DOCBOOK5_INSTALLED_XMLS)

install_docbook4_rtfs: make-dirs  $(DOCBOOK4_INSTALLED_RTFS)
install_docbook5_rtfs: make-dirs  $(DOCBOOK5_INSTALLED_RTFS)

install_docbook_individual_xhtmls: make-dirs $(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS) $(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS_CSS) $(DOCBOOK5_INSTALLED_INDIVIDUAL_XHTMLS) $(DOCBOOK5_INSTALLED_INDIVIDUAL_XHTMLS_CSS)

install_docbook_css_dirs: make-dirs $(DOCBOOK4_INSTALLED_CSS_DIRS)

PUT_CARDS_2013_DEST_INDIV = $(T2_DEST)/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/tie_your_camel.xhtml
PUT_CARDS_2013_INDIV_SCRIPT = bin/split-put-cards-into-divs.pl

all: $(PUT_CARDS_2013_DEST_INDIV)

$(PUT_CARDS_2013_DEST_INDIV): $(PUT_CARDS_2013_XHTML) $(PUT_CARDS_2013_INDIV_SCRIPT)
	perl $(PUT_CARDS_2013_INDIV_SCRIPT)

FACTOIDS_RENDER_SCRIPT = lib/factoids/gen-html.pl
FACTOIDS_TIMESTAMP = lib/factoids/TIMESTAMP
FACTOIDS_GENERATED_FILES = lib/factoids/indiv-lists-xhtmls/buffy_facts--en-US.xhtml.reduced
FACTOIDS_GEN_CMD = perl $(FACTOIDS_RENDER_SCRIPT)

# FACTOIDS_DOCS_DEST = $(filter $(T2_DEST)/humour/bits/facts/%,$(T2_DOCS_DEST))

$(FACTOIDS_TIMESTAMP): $(FACTOIDS_RENDER_SCRIPT) lib/factoids/shlomif-factoids-lists.xml
	$(FACTOIDS_GEN_CMD)

all: $(FACTOIDS_TIMESTAMP)

include lib/factoids/deps.mak

# $(FACTOIDS_DOCS_DEST): $(FACTOIDS_GENERATED_FILES)

all: manifest_html

MAN_HTML = $(T2_DEST)/MANIFEST.html

manifest_html: $(MAN_HTML)

$(MAN_HTML): ./bin/gen-manifest.pl
	perl $<

$(FACTOIDS_NAV_JSON):
	$(FACTOIDS_GEN_CMD)

LC_LECTURE_ARC_BASE = Lambda-Calculus.tar.gz
LC_LECTURE_ARC_DIR = $(T2_DEST)/lecture
LC_LECTURE_ARC = $(LC_LECTURE_ARC_DIR)/$(LC_LECTURE_ARC_BASE)

all: $(LC_LECTURE_ARC)

$(LC_LECTURE_ARC):
	(cd $(LC_LECTURE_ARC_DIR) && tar -cavf $(LC_LECTURE_ARC_BASE) Lambda-Calculus/slides)

lib/Shlomif/Homepage/SectionMenu/Sects/Humour.pm : $(FORTUNES_LIST__DEPS) $(FACTOIDS_NAV_JSON)
	touch $@

OCT_2014_SGLAU_LET_DIR = t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/
OCT_2014_SGLAU_LET_PDF = $(OCT_2014_SGLAU_LET_DIR)/letter-to-sglau.pdf
OCT_2014_SGLAU_LET_HTML = $(OCT_2014_SGLAU_LET_DIR)/letter-to-sglau.html

MY_NAME_IS_RINDOLF_SRC = $(T2_DEST)/me/rindolf/images/my-name-is-rindolf.jpg
MY_NAME_IS_RINDOLF_DEST = $(T2_DEST)/me/rindolf/images/my-name-is-rindolf-200w.jpg

all: $(OCT_2014_SGLAU_LET_PDF) $(OCT_2014_SGLAU_LET_HTML) $(MY_NAME_IS_RINDOLF_DEST)

$(OCT_2014_SGLAU_LET_PDF): t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.odt
	export A="$$(pwd)" ; cd $(OCT_2014_SGLAU_LET_DIR) && oowriter --headless --convert-to pdf "$$A/$<"

$(OCT_2014_SGLAU_LET_HTML): t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.odt
	export A="$$(pwd)" ; cd $(OCT_2014_SGLAU_LET_DIR) && oowriter --headless --convert-to html "$$A/$<"

$(MY_NAME_IS_RINDOLF_DEST): $(MY_NAME_IS_RINDOLF_SRC)
	convert -resize '200' $< $@

ENEMY_STYLE = dest/t2/humour/TheEnemy/The-Enemy-English-v7/style.css

all: $(ENEMY_STYLE)

$(ENEMY_STYLE):
	mkdir -p "$$(dirname "$@")"
	touch $@

tags:
	ctags -R --exclude='.hg/**' --exclude='*~' .

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

ZIP_MODS = $(patsubst %,%.zip,$(MODS))
XZ_MODS = $(patsubst %,%.xz,$(MODS))

DEST_MODS_DIR = $(T2_DEST)/Iglu/shlomif/mods/
DEST_ZIP_MODS = $(patsubst %,$(DEST_MODS_DIR)/%,$(ZIP_MODS))
DEST_XZ_MODS = $(patsubst %,$(DEST_MODS_DIR)/%,$(XZ_MODS))

mod_files: $(DEST_ZIP_MODS) $(DEST_XZ_MODS)

$(DEST_XZ_MODS): $(DEST_MODS_DIR)/%.xz: $(SRC_MODS_DIR)/%
	mkdir -p "$$(dirname "$@")"
	xz -9 --extreme < $< > $@

$(DEST_ZIP_MODS): $(DEST_MODS_DIR)/%.zip: $(SRC_MODS_DIR)/%
	bn='$(patsubst $(SRC_MODS_DIR)/%,%,$<)'; \
	mkdir -p "$$(dirname "$@")"; \
	(cd $(SRC_MODS_DIR) && zip -9 "$$bn.zip" "$$bn" ; ) ;  \
	mv -f "$(SRC_MODS_DIR)/$$bn.zip" $@

TECH_BLOG_DIR = lib/blogs/shlomif-tech-diary
TECH_TIPS_SCRIPT = $(TECH_BLOG_DIR)/extract-tech-tips.pl
TECH_TIPS_INPUTS = $(patsubst %,$(TECH_BLOG_DIR)/%,old-tech-diary.xhtml tech-diary.xhtml)
TECH_TIPS_OUT = lib/blogs/shlomif-tech-diary--tech-tips.xhtml

$(TECH_TIPS_OUT): $(TECH_TIPS_SCRIPT) $(TECH_TIPS_INPUTS)
	perl $(TECH_TIPS_SCRIPT) $(patsubst %,--file=%,$(TECH_TIPS_INPUTS)) --output $@ --nowrap

$(T2_DEST)/open-source/resources/tech-tips/index.html: $(TECH_TIPS_OUT)

$(T2_DEST)/philosophy/computers/web/validate-your-html/index.html: lib/blogs/validate-your-html/README.md
$(T2_DEST)/philosophy/computers/how-to-share-code-for-getting-help/index.html: lib/blogs/how-to-share-code-online/README.md

all: $(T2_CLEAN_STAMP)

$(T2_CLEAN_STAMP): $(T2_DOCS_DEST)
	find $(T2_DEST) -regex '.*\.x?html' | grep -vF -e philosophy/by-others/sscce -e WebMetaLecture/slides/examples -e homesteading/catb-heb -e t2/catb-heb.html | NO_I=1 APPLY_ADS=1 xargs $(PROCESS_ALL_INCLUDES)
	touch $@

all: lib/presentations/qp/common/VimIface.pm

lib/presentations/qp/common/VimIface.pm: lib/VimIface.pm
	$(call COPY)
