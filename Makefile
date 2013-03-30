LATEMP_WML_FLAGS := $(shell latemp-config --wml-flags)

COMMON_PREPROC_FLAGS = -I $$HOME/conf/wml/Latemp/lib
WML_FLAGS += --passoption=2,-X3074 --passoption=3,-I../lib/ \
	--passoption=3,-w -I../lib/ $(LATEMP_WML_FLAGS) \
	-DROOT~. -DLATEMP_THEME=better-scm \
	-I $${HOME}/apps/wml

TTML_FLAGS += $(COMMON_PREPROC_FLAGS) -I lib
WML_FLAGS += $(COMMON_PREPROC_FLAGS)

ALL_DEST_BASE = dest

NAV_DATA_DEP = lib/MyNavData.pm
NAV_DATA_AS_JSON_BIN = bin/nav-data-as-json

DOCS_COMMON_DEPS = template.wml $(NAV_DATA_DEP)

all: make-dirs docbook_targets fortunes-target latemp_targets css_targets sitemap_targets copy_fortunes site-source-install presentations_targets lc_pres_targets art_slogans_targets graham_func_pres_targets mojo_pres hhgg_convert lib/MathJax/README.md mathjax_dest plaintext_scripts_with_offending_extensions svg_nav_images generate_nav_data_as_json minified_javascripts

include lib/make/gmsl/gmsl

include include.mak
include rules.mak

make-dirs: $(T2_DIRS_DEST)

FORTUNES_DIR = humour/fortunes
T2_FORTUNES_DIR = t2/$(FORTUNES_DIR)

include $(T2_FORTUNES_DIR)/arcs-list.mak
include $(T2_FORTUNES_DIR)/fortunes-list.mak

include lib/make/docbook/sf-homepage-docbooks-generated.mak

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

fortunes-target: $(FORTUNES_TARGET) fortunes-compile-xmls $(T2_DEST_SHOW_CGI) $(T2_DEST_FORTUNE_SHOW_SCRIPT_TXT) $(T2_FORTUNES_DIR_HTACCESS)

$(T2_FORTUNES_DIR)/my_htaccess.conf: $(T2_FORTUNES_DIR)/gen-htaccess.pl
	(cd $(T2_FORTUNES_DIR) && make)

$(T2_FORTUNES_DIR_HTACCESS): $(T2_FORTUNES_DIR)/my_htaccess.conf
	cp -f $< $@

# t2 macros

RSYNC = rsync --progress --verbose --rsh=ssh --exclude='*.d' --exclude='**/*.d'

T2_DEST_FORTUNES = $(patsubst %,$(T2_DEST_FORTUNES_DIR)/%,$(FORTUNES_ARCS_LIST))

$(T2_DEST_FORTUNES): $(T2_DEST)/%: $(T2_SRC_DIR)/%
	cp -f $< $@

$(T2_DEST_SHOW_CGI): $(T2_SRC_FORTUNE_SHOW_SCRIPT)
	cp -f $< $@
	chmod +x $@

$(T2_DEST_FORTUNE_SHOW_SCRIPT_TXT): $(T2_SRC_FORTUNE_SHOW_SCRIPT)
	cp -f $< $@
	chmod -x $@

copy_fortunes: $(T2_DEST_FORTUNES)

test: runtest

runtest: all
	runprove Tests/*.t

ptest: all
	prove Tests/*.t

spell: all
	./bin/spell-checker-iface.sh

upload_deps: all

upload_local: upload_deps
	( cd $(T2_DEST) && $(RSYNC) -a * $${HOMEPAGE_SSH_PATH}/ )

upload_backup: upload_deps
	( cd $(T2_DEST) && $(RSYNC) -r * shlomif@alberni.textdrive.com:domains/www-backup.shlomifish.org/web/public )

upload: upload_remote

upload_remote: upload_local upload_remote_only

upload_remote_only: upload_deps upload_remote_only_without_deps

upload_remote_only_without_deps:
	( cd $(T2_DEST) && $(RSYNC) -a * $${__HOMEPAGE_REMOTE_PATH}/ )

upload_adbrite_only: upload_deps
	( cd $(T2_DEST) && $(RSYNC) --inplace -a * $${__HOMEPAGE_REMOTE_PATH}/adbrite-ie8-breakage/ )

upload_var: upload_deps upload_var_without_deps

upload_var_without_deps:
	( cd $(T2_DEST) && $(RSYNC) -a --inplace . /var/www/html/shlomif/homepage-local/ )

upload_beta: upload_deps
	( cd $(T2_DEST) && $(RSYNC) --inplace -a * $${__HOMEPAGE_REMOTE_PATH}/__Beta-kmor/ )
clean:
	rm -fr $(T2_DEST)/*
	rm -fr $(VIPE_DEST)/*

upload_hostgator: upload_deps
	( cd $(T2_DEST) && $(RSYNC) -a * 'hostgator:public_html/' )

t2/SFresume.html.wml : lib/SFresume_base.wml
	touch $@

t2/SFresume_detailed.html.wml : lib/SFresume_base.wml
	touch $@

SECTION_MENU_DEPS = lib/Shlomif/Homepage/SectionMenu.pm
PHILOSOPHY_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Essays.pm
LECTURES_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Lectures.pm
SOFTWARE_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Software.pm
HUMOUR_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Humour.pm
META_SUBSECT_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Meta.pm
PUZZLES_DEPS = $(SECTION_MENU_DEPS) lib/Shlomif/Homepage/SectionMenu/Sects/Puzzles.pm

ALL_SUBSECTS_DEPS = $(PHILOSOPHY_DEPS) $(LECTURES_DEPS) $(SOFTWARE_DEPS) $(HUMOUR_DEPS) $(META_SUBSECT_DEPS) $(PUZZLES_DEPS)

$(T2_DEST)/philosophy/Index/index.html : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl

$(T2_DEST)/me/resumes/Shlomi-Fish-Heb-Resume.html: lib/pages/t2/heb_resume.xhtml

$(FORTUNES_TARGET): $(T2_FORTUNES_DIR)/index.html.wml $(DOCS_COMMON_DEPS) $(HUMOUR_DEPS) $(T2_FORTUNES_DIR)/Makefile $(T2_FORTUNES_DIR)/ver.txt
	WML_LATEMP_PATH="$$(perl -MFile::Spec -e 'print File::Spec->rel2abs(shift)' '$@')" ; ( cd $(T2_SRC_DIR) && wml -o "$${WML_LATEMP_PATH}" $(T2_WML_FLAGS) -DLATEMP_FILENAME=$(patsubst $(T2_DEST)/%,%,$(patsubst %.wml,%,$@)) -DPACKAGE_BASE="$$( unset MAKELEVEL ; cd $(FORTUNES_DIR) && make print_package_base )" $(patsubst $(T2_SRC_DIR)/%,%,$<) )


T2_DOCS_SRC = $(patsubst $(T2_DEST)/%,$(T2_SRC_DIR)/%.wml,$(T2_DOCS_DEST))
VIPE_DOCS_SRC = $(patsubst $(VIPE_DEST)/%,$(VIPE_SRC_DIR)/%.wml,$(VIPE_DOCS_DEST))

T2_PHILOSOPHY_DOCS = \
	$(filter $(T2_DEST)/philosophy/%,$(T2_DOCS_DEST)) \
	$(filter $(T2_DEST)/prog-evolution/%,$(T2_DOCS_DEST)) \
	$(filter $(T2_DEST)/DeCSS/%,$(T2_DOCS_DEST))

$(T2_PHILOSOPHY_DOCS): %: $(PHILOSOPHY_DEPS)

T2_LECTURES_DOCS_SRC = $(filter $(T2_SRC_DIR)/lecture/%,$(T2_DOCS_SRC))

$(T2_LECTURES_DOCS_SRC): $(T2_SRC_DIR)/lecture/%.wml: $(LECTURES_DEPS)
	touch $@

VIPE_LECTURES_DOCS_SRC = $(filter $(VIPE_SRC_DIR)/lecture/%,$(VIPE_DOCS_SRC))

$(VIPE_LECTURES_DOCS_SRC): $(VIPE_SRC_DIR)/lecture/%.wml: $(LECTURES_DEPS)
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

VIPE_SOFTWARE_DOCS_SRC =

$(VIPE_SOFTWARE_DOCS_SRC): $(VIPE_SRC_DIR)/%.wml: $(SOFTWARE_DEPS)
	touch $@


#### Humour thing

T2_HUMOUR_DOCS_DEST = $(filter $(T2_DEST)/humour/%,$(T2_DOCS_DEST)) \
					 $(filter $(T2_DEST)/humour.html,$(T2_DOCS_DEST)) \
					 $(filter $(T2_DEST)/humour-heb.html,$(T2_DOCS_DEST)) \
					 $(filter $(T2_DEST)/wysiwyt.html,$(T2_DOCS_DEST)) \
					 $(filter $(T2_DEST)/wonderous.html,$(T2_DOCS_DEST))

$(T2_HUMOUR_DOCS_DEST): $(HUMOUR_DEPS)

VIPE_HUMOUR_DOCS_SRC =

$(VIPE_HUMOUR_DOCS_SRC): $(VIPE_SRC_DIR)/%.wml: $(HUMOUR_DEPS)
	touch $@


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
GPERL_DEPS = lib/Shlomif/Homepage/Amazon.pm

$(PROD_SYND_MUSIC_INC) : $(PROD_SYND_MUSIC_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/art/recommendations/music/shlomi-fish-music-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<
	./gen-helpers.pl
	$(MAKE)

$(T2_DEST)/philosophy/books-recommends/index.html : $(PROD_SYND_NON_FICTION_BOOKS_INC)

$(PROD_SYND_NON_FICTION_BOOKS_INC) : $(PROD_SYND_NON_FICTION_BOOKS_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/philosophy/books-recommends/shlomi-fish-non-fiction-books-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<
	./gen-helpers.pl
	$(MAKE)

$(T2_DEST)/humour/recommendations/films/index.html: $(PROD_SYND_FILMS_INC)

$(PROD_SYND_FILMS_INC) : $(PROD_SYND_FILMS_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/humour/recommendations/films/shlomi-fish-films-recommendations.xml $(GPERL_DEPS)
	$(GPERL) $<
	./gen-helpers.pl
	$(MAKE)


$(SITE_SOURCE_INSTALL_TARGET): INSTALL
	cp -f $< $@

SCREENPLAY_DOCS = \
    Blue-Rabbit-Log-Part-1 \
	Humanity-Movie \
	Humanity-Movie-hebrew \
	ae-interview \
	hitchhikers-guide-to-star-trek-tng-hand-tweaked \
	humanity-excerpt-for-X-G-Screenplay-demo \
	Star-Trek--We-the-Living-Dead \
	Summerschool-at-the-NSA \
	selina-mandrake-the-slayer \
	sussman-interview \
	TOW_Fountainhead_1  \
	TOW_Fountainhead_2

FICTION_DOCS = \
    fiction-text-example-for-X-G-Fiction-demo \
	human-hacking-field-guide-hebrew-v2 \
	The-Enemy-Hebrew-rev6 \
	The-Enemy-Hebrew-v7 \
	The-Pope-Died-on-Sunday-hebrew \
	The-Pope-Died-on-Sunday-english

DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS_CSS = $(patsubst %,%/style.css,$(DOCBOOK4_INDIVIDUAL_XHTMLS))
DOCBOOK4_INSTALLED_CSS_DIRS = $(foreach doc,$(DOCBOOK4_DOCS),$(T2_DEST)/$(call get,DOCBOOK4_DIRS_MAP,$(doc))/docbook-css)
DOCMAKE_STYLE_CSS = $(DOCMAKE_XSLT_PATH)/style.css

DOCBOOK4_BASE_DIR = lib/docbook/4
DOCBOOK4_RENDERED_DIR = $(DOCBOOK4_BASE_DIR)/rendered
DOCBOOK4_ALL_IN_ONE_XHTML_DIR = $(DOCBOOK4_BASE_DIR)/essays

SCREENPLAY_XML_BASE_DIR = lib/screenplay-xml
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

DOCBOOK5_FOS = $(patsubst %,$(DOCBOOK5_FO_DIR)/%.fo,$(DOCBOOK5_DOCS))

DOCBOOK5_FOR_OOO_XHTMLS = $(patsubst %,$(DOCBOOK5_FOR_OOO_XHTML_DIR)/%.html,$(DOCBOOK5_DOCS))

DOCBOOK5_PDFS = $(patsubst %,$(DOCBOOK5_PDF_DIR)/%.pdf,$(DOCBOOK5_DOCS))

DOCBOOK5_RTFS = $(patsubst %,$(DOCBOOK5_RTF_DIR)/%.rtf,$(DOCBOOK5_DOCS))

DOCBOOK5_INDIVIDUAL_XHTMLS = $(patsubst %,$(DOCBOOK5_INDIVIDUAL_XHTML_DIR)/%,$(DOCBOOK5_DOCS))

DOCBOOK5_ALL_IN_ONE_XHTMLS = $(patsubst %,$(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml,$(DOCBOOK5_DOCS))


SCREENPLAY_RENDERED_HTMLS = $(patsubst %,$(SCREENPLAY_XML_RENDERED_HTML_DIR)/%.html,$(SCREENPLAY_DOCS))
SCREENPLAY_XML_HTMLS = $(patsubst %,$(SCREENPLAY_XML_HTML_DIR)/%.html,$(SCREENPLAY_DOCS))
SCREENPLAY_XML_FOR_OOO_XHTMLS = $(patsubst %,$(SCREENPLAY_XML_FOR_OOO_XHTML_DIR)/%.xhtml,$(SCREENPLAY_DOCS))

all: $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_XML_HTMLS)

include lib/make/docbook/sf-screenplays.mak

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

SCREENPLAY_SOURCES_ON_DEST = $(T2_DEST)/humour/TOWTF/TOW_Fountainhead_1.txt $(T2_DEST)/humour/TOWTF/TOW_Fountainhead_2.txt $(T2_DEST)/humour/humanity/Humanity-Movie.txt $(T2_DEST)/humour/humanity/Humanity-Movie-hebrew.txt $(T2_DEST)/humour/Star-Trek/We-the-Living-Dead/star-trek--we-the-living-dead.txt $(T2_DEST)/humour/Selina-Mandrake/selina-mandrake-the-slayer.txt $(T2_DEST)/open-source/interviews/ae-interview.txt $(T2_DEST)/open-source/interviews/sussman-interview.txt $(T2_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-Part-1.txt $(T2_DEST)/humour/by-others/hitchhiker-guide-to-star-trek-tng-hand-tweaked.txt $(T2_DEST)/humour/Selina-Mandrake/ideas.txt

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
	cp -f $< $@

hhgg_convert: $(HHGG_CONVERT_SCRIPT_DEST)

FRON_IMAGE_BASE = fron-demon-illustration-small-indexed.png

POPE__VCS_DIR = lib/fiction-xml/from-vcs/The-Pope-Died-on-Sunday
POPE_ENG_FICTION_XML_SOURCE = $(POPE__VCS_DIR)/Pope/text/The-Pope-Died-on-Sunday-english.fiction-text.txt
POPE_HEB_FICTION_XML_SOURCE = $(POPE__VCS_DIR)/Pope/text/The-Pope-Died-on-Sunday-hebrew.fiction-text.txt
POPE_ENG_FICTION_TXT_FROM_VCS = lib/fiction-xml/txt/The-Pope-Died-on-Sunday-english.txt
POPE_HEB_FICTION_TXT_FROM_VCS = lib/fiction-xml/txt/The-Pope-Died-on-Sunday-hebrew.txt

HHFG__VCS_DIR = lib/fiction-xml/from-vcs/Human-Hacking-Field-Guide
HHFG_ENG_DOCBOOK5_SOURCE = $(HHFG__VCS_DIR)/HHFG/text/human-hacking-field-guide--english.db5.xml
HHFG_HEB_FICTION_XML_SOURCE = $(HHFG__VCS_DIR)/HHFG/text/human-hacking-field-guide--hebrew.fiction-text.txt
HHFG_ENG_DOCBOOK5_FROM_VCS = lib/docbook/5/xml/human-hacking-field-guide-v2.xml
HHFG_HEB_FICTION_TXT_FROM_VCS = lib/fiction-xml/txt/human-hacking-field-guide-hebrew-v2.txt

$(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng.txt : $(HHGG_CONVERT_SCRIPT_SRC) t2/humour/by-others/hitchhiker-guide-to-star-trek-tng.txt
	perl $<

$(T2_DEST)/humour/by-others/hitchhiker-guide-to-star-trek-tng-hand-tweaked.txt: $(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng-hand-tweaked.txt
	cp -f $< $@

$(T2_DEST)/humour/humanity/Humanity-Movie.txt: $(SCREENPLAY_XML_TXT_DIR)/Humanity-Movie.txt
	cp -f $< $@

$(T2_DEST)/humour/humanity/Humanity-Movie-hebrew.txt: $(SCREENPLAY_XML_TXT_DIR)/Humanity-Movie-hebrew.txt
	cp -f $< $@

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-hebrew.txt: $(FICTION_XML_TXT_DIR)/The-Pope-Died-on-Sunday-hebrew.txt
	cp -f $< $@

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-english.txt: $(FICTION_XML_TXT_DIR)/The-Pope-Died-on-Sunday-english.txt
	cp -f $< $@

$(HHFG_HEB_V2_DEST): $(FICTION_XML_TXT_DIR)/$(HHFG_HEB_V2_TXT)
	cp -f $< $@

$(HHFG_HEB_V2_XSLT_DEST): $(FICTION_XML_DB5_XSLT_DIR)/human-hacking-field-guide-hebrew-v2.xslt
	cp -f $< $@

# Rebuild the embedded screenplays pages in the $(T2_DEST) after they are
# modified.
$(T2_DEST)/humour/Blue-Rabbit-Log/part-1.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/Blue-Rabbit-Log-Part-1.html
$(T2_DEST)/humour/humanity/ongoing-text.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/Humanity-Movie.html
$(T2_DEST)/humour/humanity/ongoing-text-hebrew.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/Humanity-Movie-hebrew.html
$(T2_DEST)/humour/Summerschool-at-the-NSA/ongoing-text.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/Summerschool-at-the-NSA.html
$(T2_DEST)/humour/Selina-Mandrake/ongoing-text.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/selina-mandrake-the-slayer.html
$(T2_DEST)/humour/Star-Trek/We-the-Living-Dead/ongoing-text.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/Star-Trek--We-the-Living-Dead.html
$(T2_DEST)/humour/TOWTF/TOW_Fountainhead_1.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/TOW_Fountainhead_1.html
$(T2_DEST)/humour/by-others/hitchhiker-guide-to-star-trek-tng-htmlised.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/hitchhikers-guide-to-star-trek-tng-hand-tweaked.html
$(T2_DEST)/humour/TOWTF/TOW_Fountainhead_2.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/TOW_Fountainhead_2.html
$(T2_DEST)/open-source/interviews/adrian-ettlinger.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/ae-interview.html
$(T2_DEST)/open-source/interviews/sussman.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/sussman-interview.html
$(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.html: $(SCREENPLAY_XML_TXT_DIR)/humanity-excerpt-for-X-G-Screenplay-demo.txt
$(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/humanity-excerpt-for-X-G-Screenplay-demo.html
$(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.html: $(FICTION_XML_TXT_DIR)/fiction-text-example-for-X-G-Fiction-demo.txt
$(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.html: $(DOCBOOK5_RENDERED_DIR)/fiction-text-example-for-X-G-Fiction-demo.xhtml

# Rebuild the embedded docbook4 pages in the $(T2_DEST) after they are
# modified.

$(T2_DEST)/philosophy/computers/high-quality-software/rev2/index.html : $(DOCBOOK4_RENDERED_DIR)/what-makes-software-high-quality-rev2.html
$(T2_DEST)/philosophy/computers/high-quality-software/index.html : $(DOCBOOK4_RENDERED_DIR)/what-makes-software-high-quality.html

PUT_CARDS_2013_XHTML = lib/pages/t2/philosophy/putting-all-cards-on-the-table.xhtml
PUT_CARDS_2013_DEST = $(T2_DEST)/philosophy/philosophy/put-cards-2003.xhtml

all: $(PUT_CARDS_2013_DEST)

$(T2_DEST)/philosophy/philosophy/putting-all-cards-on-the-table-2013/index.html : $(PUT_CARDS_2013_XHTML)

$(PUT_CARDS_2013_DEST): $(PUT_CARDS_2013_XHTML)
	cp -f $< $@

$(T2_DEST)/philosophy/computers/education/introductory-language/index.html: $(DOCBOOK4_RENDERED_DIR)/introductory-language.html

$(T2_DEST)/philosophy/computers/software-management/perfect-workplace/perfect-it-workplace.xhtml : $(DOCBOOK4_RENDERED_DIR)/perfect-it-workplace.html

# Rebuild the embedded docbook5 pages in the $(T2_DEST) after they are
# modified.

$(T2_DEST)/philosophy/psychology/hypomanias/index.html: $(DOCBOOK5_RENDERED_DIR)/dealing-with-hypomanias.xhtml

$(T2_DEST)/philosophy/perl-newcomers/v1/index.html: $(DOCBOOK5_RENDERED_DIR)/usability-of-perl-world-for-newcomers.xhtml

$(T2_DEST)/philosophy/case-for-file-swapping/revision-3/index.html: $(DOCBOOK4_RENDERED_DIR)/case-for-file-swapping-rev3.html

$(T2_DEST)/philosophy/politics/drug-legalisation/index.html: $(DOCBOOK5_RENDERED_DIR)/case-for-drug-legalisation-v3.xhtml

$(T2_DEST)/philosophy/computers/open-source/foss-licences-wars/index.html : $(DOCBOOK4_RENDERED_DIR)/foss-licences-wars.html

$(T2_DEST)/philosophy/obj-oss/rev2/index.html: $(DOCBOOK5_RENDERED_DIR)/objectivism-and-open-source.xhtml

$(T2_DEST)/open-source/projects/Spark/mission/Spark-Pre-Birth-of-a-Modern-Lisp/index.html : $(DOCBOOK4_RENDERED_DIR)/Spark-Pre-Birth-of-a-Modern-Lisp.html

$(T2_DEST)/philosophy/computers/software-management/end-of-it-slavery/index.html : $(DOCBOOK4_RENDERED_DIR)/end-of-it-slavery.html


# Rebuild the pages containing the links to t2/humour/stories upon changing
# the lib/stories.

$(T2_DEST)/humour/index.html $(T2_DEST)/humour/stories/index.html $(T2_DEST)/humour/stories/Star-Trek/index.html $(T2_DEST)/humour/stories/Star-Trek/We-the-Living-Dead/index.html $(T2_DEST)/humour/TheEnemy/index.html: lib/stories/stories-list.wml

$(T2_DEST)/humour/humanity/index.html $(T2_DEST)/humour/humanity/ongoing-text.html $(T2_DEST)/humour/humanity/buy-the-fish-in-hebrew.html $(T2_DEST)/humour/humanity/ongoing-text-hebrew.html : lib/stories/blurbs.wml

$(T2_DEST)/philosophy/computers/software-management/perfect-workplace/v2/content.html: $(DOCBOOK5_RENDERED_DIR)/perfect-it-workplace-v2.xhtml

$(T2_DEST)/links.html $(T2_DEST)/philosophy/computers/web/create-a-great-personal-homesite/index.html $(T2_DEST)/philosophy/computers/web/create-a-great-personal-homesite/rev2.html $(T2_DEST)/humour/by-others/division-two/index.html: lib/div2mag.wml

$(T2_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-Part-1.txt: $(SCREENPLAY_XML_TXT_DIR)/Blue-Rabbit-Log-Part-1.txt
	cp -f $< $@

$(T2_DEST)/humour/Star-Trek/We-the-Living-Dead/star-trek--we-the-living-dead.txt: $(SCREENPLAY_XML_TXT_DIR)/Star-Trek--We-the-Living-Dead.txt
	cp -f $< $@

$(T2_DEST)/open-source/interviews/ae-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/ae-interview.txt
	cp -f $< $@

$(T2_DEST)/open-source/interviews/sussman-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/sussman-interview.txt
	cp -f $< $@

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-hebrew.xml: $(DOCBOOK5_XML_DIR)/The-Pope-Died-on-Sunday-hebrew.xml
	cp -f $< $@

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-english.xml: $(DOCBOOK5_XML_DIR)/The-Pope-Died-on-Sunday-english.xml
	cp -f $< $@

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday--Hebrew-Text.html: $(DOCBOOK5_RENDERED_DIR)/The-Pope-Died-on-Sunday-hebrew.xhtml

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday--English-Text.html: $(DOCBOOK5_RENDERED_DIR)/The-Pope-Died-on-Sunday-english.xhtml

$(T2_DEST)/humour/human-hacking/hebrew-v2.html: $(DOCBOOK5_RENDERED_DIR)/human-hacking-field-guide-hebrew-v2.xhtml

$(T2_DEST)/humour/TheEnemy/The-Enemy-rev6.html: $(DOCBOOK5_RENDERED_DIR)/The-Enemy-Hebrew-rev6.xhtml

$(T2_DEST)/humour/TheEnemy/The-Enemy-Hebrew-v7.html: $(DOCBOOK5_RENDERED_DIR)/The-Enemy-Hebrew-v7.xhtml

$(T2_DEST)/humour/TheEnemy/The-Enemy-English-v7.html: $(DOCBOOK5_RENDERED_DIR)/The-Enemy-English-v7.xhtml

%.show:
	@echo "$* = $($*)"

tidy: all
	perl bin/run-tidy.pl

.PHONY: install_docbook4_pdfs install_docbook_xmls install_docbook4_rtfs install_docbook_individual_xhtmls install_docbook_css_dirs

install_docbook4_pdfs: make-dirs $(DOCBOOK4_INSTALLED_PDFS)
install_docbook5_pdfs: make-dirs $(DOCBOOK5_INSTALLED_PDFS)

install_docbook4_xmls: make-dirs $(DOCBOOK4_INSTALLED_XMLS)
install_docbook5_xmls: make-dirs $(DOCBOOK5_INSTALLED_XMLS)

install_docbook4_rtfs: make-dirs  $(DOCBOOK4_INSTALLED_RTFS)
install_docbook5_rtfs: make-dirs  $(DOCBOOK5_INSTALLED_RTFS)

install_docbook_individual_xhtmls: make-dirs $(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS) $(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS_CSS) $(DOCBOOK5_INSTALLED_INDIVIDUAL_XHTMLS) $(DOCBOOK5_INSTALLED_INDIVIDUAL_XHTMLS_CSS)


install_docbook_css_dirs: make-dirs $(DOCBOOK4_INSTALLED_CSS_DIRS)

# This copies all the .pdf's at once - not ideal, but still
# working.

$(DOCBOOK4_INSTALLED_CSS_DIRS) : lib/sgml/docbook-css/docbook-css-0.4/
	mkdir -p $@
	rsync -r -v $< $@
	find $@ -name '.svn' -print0 | xargs -0 rm -fr

FORTUNES_XHTMLS_DIR = lib/fortunes/xhtmls

FORTUNES_XMLS_BASE = $(addsuffix .xml,$(FORTUNES_FILES_BASE))
FORTUNES_XMLS_SRC = $(patsubst %,$(T2_FORTUNES_DIR)/%,$(FORTUNES_XMLS_BASE))
FORTUNES_XHTMLS = $(patsubst $(T2_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_TEXTS = $(patsubst %.xml,%,$(FORTUNES_XMLS_SRC))
FORTUNES_ATOM_FEED = $(T2_FORTUNES_DIR)/fortunes-shlomif-all.atom
FORTUNES_RSS_FEED = $(T2_FORTUNES_DIR)/fortunes-shlomif-all.rss
FORTUNES_SQLITE_DB = $(T2_FORTUNES_DIR)/fortunes-shlomif-lookup.sqlite3

fortunes-compile-xmls: $(FORTUNES_XHTMLS) $(FORTUNES_TEXTS) $(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED) $(FORTUNES_SQLITE_DB)

# The touch is to make sure we compile the .html.wml again.

FORTUNES_CONVERT_TO_XHTML_SCRIPT = $(T2_FORTUNES_DIR)/convert-to-xhtml.pl

$(FORTUNES_XHTMLS): $(FORTUNES_XHTMLS_DIR)/%.xhtml : $(T2_FORTUNES_DIR)/%.xml $(FORTUNES_CONVERT_TO_XHTML_SCRIPT)
	bash $(T2_FORTUNES_DIR)/run-validator.bash $< && \
	perl $(FORTUNES_CONVERT_TO_XHTML_SCRIPT) $< $@ && \
	touch $(patsubst %.xml,%.html.wml,$<)

$(FORTUNES_TEXTS): $(T2_FORTUNES_DIR)/%: $(T2_FORTUNES_DIR)/%.xml
	bash $(T2_FORTUNES_DIR)/run-validator.bash $< && \
	perl $(T2_FORTUNES_DIR)/convert-to-plaintext.pl $< $@

$(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED): $(T2_FORTUNES_DIR)/generate-web-feeds.pl $(FORTUNES_XMLS_SRC)
	perl $< --atom $(FORTUNES_ATOM_FEED) --rss $(FORTUNES_RSS_FEED) --dir $(T2_FORTUNES_DIR)

FORTUNES_LIST_PM = lib/Shlomif/Homepage/FortuneCollections.pm
$(FORTUNES_SQLITE_DB): $(T2_FORTUNES_DIR)/populate-sqlite-database.pl $(FORTUNES_XHTMLS) $(FORTUNES_LIST_PM)
	perl -Ilib $<

$(T2_DEST)/humour/fortunes/index.html: $(FORTUNES_LIST_PM)

lib/Shlomif/Homepage/SectionMenu/Sects/Humour.pm : $(FORTUNES_LIST_PM)
	touch $@

$(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS_CSS): %: $(DOCMAKE_STYLE_CSS)
	cp -f $< $@

$(DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS): %: $(DOCMAKE_STYLE_CSS)
	cp -f $< $@

MOJOLICIOUS_LECTURE_SLIDE1 = $(T2_DEST)/lecture/Perl/Lightning/Mojolicious/mojolicious-slides.html

HACKING_DOC = $(T2_DEST)/open-source/resources/how-to-contribute-to-my-projects/HACKING.html

mojo_pres: $(MOJOLICIOUS_LECTURE_SLIDE1) $(HACKING_DOC)

$(MOJOLICIOUS_LECTURE_SLIDE1): t2/lecture/Perl/Lightning/Mojolicious/mojolicious.asciidoc.txt
	asciidoc -o $@ $<

$(DOCBOOK4_BASE_DIR)/xml/Spark-Pre-Birth-of-a-Modern-Lisp.xml: t2/open-source/projects/Spark/mission/Spark-Pre-Birth-of-a-Modern-Lisp.txt
	asciidoc --backend=docbook -o $@ $<

$(HACKING_DOC): t2/open-source/resources/how-to-contribute-to-my-projects/HACKING.txt
	asciidoc -o $@ $<

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

HHFG_V2_IMAGES_DEST_DIR = $(T2_DEST)/humour/human-hacking/human-hacking-field-guide-v2
HHFG_V2_IMAGES_DEST = $(patsubst %,$(HHFG_V2_IMAGES_DEST_DIR)/%,$(DOCBOOK4_HHFG_IMAGES_RAW))

docbook_hhfg_images: $(DOCBOOK4_HHFG_IMAGES_DEST) $(HHFG_V2_IMAGES_DEST)

$(DOCBOOK4_HHFG_IMAGES_DEST): $(DOCBOOK4_HHFG_DEST_DIR)/%: $(DOCBOOK4_BASE_DIR)/style/human-hacking-field-guide/%
	cp -f $< $@

$(HHFG_V2_IMAGES_DEST): $(HHFG_V2_IMAGES_DEST_DIR)/%: $(DOCBOOK4_BASE_DIR)/style/human-hacking-field-guide/%
	cp -f $< $@

DOCBOOK5_XSL_STYLESHEETS_PATH := $(HOME)/Download/unpack/file/docbook/docbook-xsl-ns-snapshot

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
DOCBOOK5_RELAXNG = rng/docbook.rng

$(DOCBOOK5_ALL_IN_ONE_XHTMLS): $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml: $(DOCBOOK5_SOURCES_DIR)/%.xml
	jing $(DOCBOOK5_RELAXNG) $<
	$(DOCMAKE) --stringparam "root.filename=$@.temp.xml" --basepath $(DOCBOOK5_XSL_STYLESHEETS_PATH) -x $(DOCBOOK5_XSL_ONECHUNK_XSLT_STYLESHEET) xhtml-1_1 $<
	xsltproc --output $@ ./bin/clean-up-docbook-xhtml-1.1.xslt $@.temp.xml.html
	rm -f $@.temp.xml.html
	perl -lpi -e 's/[ \t]+\z//' $@

$(DOCBOOK5_RENDERED_DIR)/%.xhtml: $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml
	./bin/clean-up-docbook-5-xsl-xhtml-1_1.pl -o $@ $<

$(DOCBOOK5_FO_DIR)/%.fo: $(DOCBOOK5_SOURCES_DIR)/%.xml
	$(DOCMAKE_WITH_PARAMS) --basepath $(DOCBOOK5_XSL_STYLESHEETS_PATH) -o $@ -x $(DOCBOOK5_XSL_FO_XSLT_STYLESHEET) fo $<
	perl -lpi -e 's/[ \t]+\z//' $@

$(DOCBOOK5_PDF_DIR)/%.pdf: $(DOCBOOK5_FO_DIR)/%.fo
	fop -fo $< -pdf $@

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

art_slogans_targets: $(ART_SLOGANS_THUMBS)

$(ART_SLOGANS_PNGS): %.png: %.svg
	inkscape --export-png="$(patsubst %.png,%.temp.png,$@)" $<
	pngcrush $(patsubst %.png,%.temp.png,$@) $@
	rm -f $(patsubst %.png,%.temp.png,$@)

$(ART_SLOGANS_THUMBS): %.thumb.png: %.png
	convert -resize '200' $< $(patsubst %.png,%.temp.png,$@)
	pngcrush $(patsubst %.png,%.temp.png,$@) $@
	rm -f $(patsubst %.png,%.temp.png,$@)

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
	(cd $(patsubst %/slides/start.html,%,$@) && \
		shspork -make && \
		(cd slides/ && (for I in *.html ; do tidy -asxhtml -o "$$I".new "$$I" ; mv -f "$$I".new "$$I" ; perl -lpi -e 's/[\t ]+\z//' "$$I" ; done)) \
	)
	cp -f common/favicon.png $(patsubst %/start.html,%,$@)/

lib/presentations/spork/Vim/beginners/Spork.slides: lib/presentations/spork/Vim/beginners/Spork.slides.source
	cat $< | perl -pe 's!^\+!!' > $@

GEN_STYLE_CSS_FILES = style.css style-2008.css fortunes.css fortunes_show.css fort_total.css style-404.css screenplay.css jqui-override.css

T2_CSS_TARGETS = $(patsubst %,$(T2_DEST)/%,$(GEN_STYLE_CSS_FILES))
VIPE_CSS_TARGETS = $(patsubst %,$(VIPE_DEST)/%,$(GEN_STYLE_CSS_FILES))

CSS_GEN_SCRIPT = bin/gen-css.pl

css_targets: $(T2_CSS_TARGETS) $(VIPE_CSS_TARGETS) $(T2_DEST)/screenplay.css

SASS_STYLE = compressed
# SASS_STYLE = expanded
SASS_CMD = sass --style $(SASS_STYLE)

$(T2_CSS_TARGETS): $(T2_DEST)/%.css: lib/sass/%.sass
	$(SASS_CMD) $< $@

$(VIPE_CSS_TARGETS): $(VIPE_DEST)/%.css: lib/sass/%.sass
	$(SASS_CMD) $< $@

FORT_SASS_DEPS = lib/sass/fortunes.sass
COMMON_SASS_DEPS = lib/sass/common-body.sass

$(T2_DEST)/style.css $(T2_DEST)/style-2008.css : lib/sass/common-style.sass $(COMMON_SASS_DEPS) lib/sass/lang_switch.sass $(FORT_SASS_DEPS) lib/sass/code_block.sass lib/sass/jqtree.sass lib/sass/treeview.sass


$(T2_DEST)/style.css: lib/sass/smoked-wp-theme.sass lib/sass/footer.sass

$(T2_DEST)/fortunes_show.css: $(COMMON_SASS_DEPS)

$(T2_DEST)/fort_total.css: $(FORT_SASS_DEPS) lib/sass/fortunes.sass lib/sass/fortunes_show.sass $(COMMON_SASS_DEPS) lib/sass/screenplay.sass

$(T2_DEST)/personal.html $(T2_DEST)/personal-heb.html: lib/pages/t2/personal.wml
$(T2_DEST)/humour.html $(T2_DEST)/humour-heb.html: lib/pages/t2/humour.wml
$(T2_DEST)/work/hire-me/index.html $(T2_DEST)/work/hire-me/hebrew.html: lib/pages/t2/hire-me.wml

$(T2_DEST)/open-source/projects/Module-Format/index.html $(T2_DEST)/open-source/projects/File-Find-Object/index.html $(T2_DEST)/open-source/projects/File-Dir-Dumper/index.html $(T2_DEST)/open-source/projects/XML-Grammar/Fiction/index.html $(T2_DEST)/open-source/projects/black-hole-solitaire-solver/index.html $(T2_DEST)/open-source/projects/japanese-puzzle-games/abc-path/index.html $(T2_DEST)/meta/FAQ/index.html $(T2_DEST)/open-source/contributions/index.html: lib/cpan_dists.wml

docbook_extended: $(DOCBOOK4_FOS) $(DOCBOOK4_PDFS) \
	$(DOCBOOK5_FOS) $(DOCBOOK5_PDFS) \
	install_docbook4_pdfs install_docbook4_rtfs \
	install_docbook5_pdfs install_docbook5_rtfs

docbook_indiv: $(DOCBOOK4_INDIVIDUAL_XHTMLS)


docbook_targets: docbook4_targets screenplay_targets docbook5_targets \
	install_docbook4_xmls install_docbook_individual_xhtmls install_docbook_css_dirs docbook_hhfg_images install_docbook5_xmls html_tutorial \
	pope_fiction selina_mandrake hhfg_fiction

docbook4_targets: $(DOCBOOK4_TARGETS) $(DOCBOOK4_ALL_IN_ONE_XHTMLS) $(DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS)

docbook5_targets: $(DOCBOOK5_TARGETS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS_CSS) $(DOCBOOK5_RENDERED_HTMLS) $(DOCBOOK5_FOS) $(DOCBOOK5_FOR_OOO_XHTMLS)

$(T2_DEST)/lecture/Perl/Newbies/lecture5-heb-notes.html: $(T2_SRC_DIR)/lecture/Perl/Newbies/lecture5-notes.txt bin/lecture5-txt2html.bash

$(T2_DEST)/philosophy/by-others/perlcast-transcript--tom-limoncelli-interview/index.html: lib/htmls/from-mediawiki/processed/Perlcast_Transcript_-_Interview_with_Tom_Limoncelli.html

HTML_TUT_BASE = lib/presentations/docbook/html-tutorial/hebrew-html-tutorial

HTML_TUT_HEB_DIR = $(HTML_TUT_BASE)/hebrew-html-tutorial
HTML_TUT_HEB_HTML = $(HTML_TUT_HEB_DIR)/index.html
HTML_TUT_HEB_TT = $(HTML_TUT_BASE)/hebrew-html-tutorial.xml.tt
DEST_HTML_TUT_BASE = $(T2_DEST)/lecture/HTML-Tutorial/v1/xhtml1/hebrew
DEST_HTML_TUT = $(DEST_HTML_TUT_BASE)/index.html

$(POPE_ENG_FICTION_TXT_FROM_VCS): $(POPE_ENG_FICTION_XML_SOURCE)
	cp -f $< $@

$(POPE_HEB_FICTION_TXT_FROM_VCS): $(POPE_HEB_FICTION_XML_SOURCE)
	cp -f $< $@

$(HHFG_ENG_DOCBOOK5_FROM_VCS): $(HHFG_ENG_DOCBOOK5_SOURCE)
	cp -f $< $@

$(HHFG_HEB_FICTION_TXT_FROM_VCS): $(HHFG_HEB_FICTION_XML_SOURCE)
	cp -f $< $@

html_tutorial: $(DEST_HTML_TUT)

selina_mandrake: $(SELINA_MANDRAKE_ENG_SCREENPLAY_XML_SOURCE) $(SELINA_MANDRAKE_ENG_TXT_FROM_VCS) $(SELINA_MANDRAKE_ENG_FRON_IMAGE__DEST)

pope_fiction: $(POPE_ENG_FICTION_XML_SOURCE)

hhfg_fiction: $(HHFG_ENG_DOCBOOK5_SOURCE) $(HHFG_HEB_FICTION_XML_SOURCE)

screenplay_targets: $(ST_WTLD_TEXT_IN_TREE) $(SCREENPLAY_XMLS) $(SCREENPLAY_HTMLS) $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_SOURCES_ON_DEST) $(FICTION_TEXT_SOURCES_ON_DEST) $(SCREENPLAY_XML_FOR_OOO_XHTMLS) $(SELINA_MANDRAKE_ENG_SCREENPLAY_XML_SOURCE) $(SUMMERSCHOOL_AT_THE_NSA_ENG_SCREENPLAY_XML_SOURCE)

$(DEST_HTML_TUT): $(HTML_TUT_HEB_HTML)
	mkdir -p $(DEST_HTML_TUT_BASE)
	rsync -r $(HTML_TUT_HEB_DIR)/ $(DEST_HTML_TUT_BASE)

$(HTML_TUT_HEB_HTML): $(HTML_TUT_HEB_TT)
	cd $(HTML_TUT_BASE) && make

$(HTML_TUT_HEB_TT):
	cd lib/presentations/docbook && hg clone ssh://hg@bitbucket.org/shlomif/html-tutorial

$(POPE_ENG_FICTION_XML_SOURCE):
	cd lib/fiction-xml/from-vcs && git clone https://github.com/shlomif/The-Pope-Died-on-Sunday

$(HHFG_ENG_DOCBOOK5_SOURCE):
	cd lib/fiction-xml/from-vcs && git clone https://github.com/shlomif/Human-Hacking-Field-Guide

update_html_tut: update_html_tut_hg html_tutorial

update_html_tut_hg:
	cd $(HTML_TUT_BASE) && (hg pull ; hg update)

include deps.mak

lib/MathJax/README.md :
	cd lib && git clone git://github.com/mathjax/MathJax.git MathJax && \
		cd MathJax && git checkout v2.1-latest

MATHJAX_DEST_DIR = $(T2_DEST)/js/MathJax

mathjax_dest: $(MATHJAX_DEST_DIR)/README.md

$(MATHJAX_DEST_DIR)/README.md : lib/MathJax/README.md
	cd lib && rsync -r -v --progress MathJax/ ../$(T2_DEST)/js/MathJax/
	rm -fr $(MATHJAX_DEST_DIR)/.git
	rm -fr $(MATHJAX_DEST_DIR)/.gitignore

SCRIPTS_WITH_OFFENDING_EXTENSIONS = t2/MathVentures/gen-bugs-in-square-svg.pl t2/open-source/bits-and-bobs/nowplay-xchat.pl t2/open-source/bits-and-bobs/pmwiki-revert.pl t2/open-source/bits-and-bobs/convert-kabc-dist-lists.pl

SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS = $(patsubst $(T2_SRC_DIR)/%.pl,$(T2_DEST)/%-pl.txt,$(SCRIPTS_WITH_OFFENDING_EXTENSIONS))

plaintext_scripts_with_offending_extensions: $(SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS)

$(SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS): $(T2_DEST)/%-pl.txt: $(T2_SRC_DIR)/%.pl
	cp -f $< $@

SVG_NAV_IMAGES = \
	$(T2_DEST)/images/sect-arr-left-disabled.svg \
	$(T2_DEST)/images/sect-arr-left-pressed.svg \
	$(T2_DEST)/images/sect-arr-left.svg \
	$(T2_DEST)/images/sect-arr-right-disabled.svg \
	$(T2_DEST)/images/sect-arr-right-pressed.svg \
	$(T2_DEST)/images/sect-arr-right.svg \
	$(T2_DEST)/images/sect-arr-up-disabled.svg \
	$(T2_DEST)/images/sect-arr-up-pressed.svg \
	$(T2_DEST)/images/sect-arr-up.svg


svg_nav_images: $(SVG_NAV_IMAGES)

$(SVG_NAV_IMAGES): lib/images/navigation/section/sect-nav-arrows.pl
	perl $<

NAV_DATA_AS_JSON = $(T2_DEST)/_data/nav.json

generate_nav_data_as_json: $(NAV_DATA_AS_JSON)

$(NAV_DATA_AS_JSON): $(NAV_DATA_DEP) $(NAV_DATA_AS_JSON_BIN) lib/Shlomif/Homepage/NavData/JSON.pm $(ALL_SUBSECTS_DEPS)
	./$(NAV_DATA_AS_JSON_BIN) -o $@

$(T2_DEST)/site-map/index.html: $(ALL_SUBSECTS_DEPS)

generate_nav_data_as_json:

JSMIN = bin/jsmin
$(JSMIN): lib/jsmin/jsmin.c
	gcc -o $@ -O2 -Wall $<

JQTREE_SRC = common/js/tree.jquery.js
JQTREE_MIN_DEST = dest/t2-homepage/js/tree.jq.js

$(JQTREE_MIN_DEST): $(JQTREE_SRC) $(JSMIN)
	$(JSMIN) < $(JQTREE_SRC) > $(JQTREE_MIN_DEST)

minified_javascripts: $(JQTREE_MIN_DEST)
