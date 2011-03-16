LATEMP_WML_FLAGS := $(shell latemp-config --wml-flags)

COMMON_PREPROC_FLAGS = -I $$HOME/conf/wml/Latemp/lib 
WML_FLAGS += --passoption=2,-X3074 --passoption=3,-I../lib/ \
	--passoption=3,-w -I../lib/ $(LATEMP_WML_FLAGS) \
	-DROOT~. -DLATEMP_THEME=better-scm \
	-I $${HOME}/apps/wml

TTML_FLAGS += $(COMMON_PREPROC_FLAGS) -I lib
WML_FLAGS += $(COMMON_PREPROC_FLAGS)

ALL_DEST_BASE = dest


DOCS_COMMON_DEPS = template.wml lib/MyNavData.pm

all: make-dirs docbook_targets fortunes-target latemp_targets css_targets sitemap_targets copy_fortunes site-source-install presentations_targets lc_pres_targets art_slogans_targets graham_func_pres_targets mojo_pres hhgg_convert

include lib/make/gmsl/gmsl

include include.mak
include rules.mak
include deps.mak

make-dirs: $(T2_DIRS_DEST) 

FORTUNES_DIR = humour/fortunes
T2_FORTUNES_DIR = t2/$(FORTUNES_DIR)

include $(T2_FORTUNES_DIR)/arcs-list.mak
include $(T2_FORTUNES_DIR)/fortunes-list.mak

include lib/make/docbook/sf-homepage-docbooks-generated.mak

SITE_SOURCE_INSTALL_TARGET = $(T2_DEST)/meta/site-source/INSTALL
FORTUNES_TARGET =  $(T2_DEST)/$(FORTUNES_DIR)/index.html

site-source-install: $(SITE_SOURCE_INSTALL_TARGET)

fortunes-target: $(FORTUNES_TARGET) fortunes-compile-xmls

# t2 macros

RSYNC = rsync --progress --verbose --rsh=ssh

T2_DEST_FORTUNES = $(patsubst %,$(T2_DEST)/$(FORTUNES_DIR)/%,$(FORTUNES_ARCS_LIST))

$(T2_DEST_FORTUNES): $(T2_DEST)/%: $(T2_SRC_DIR)/%
	cp -f $< $@

copy_fortunes: $(T2_DEST_FORTUNES)

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

$(T2_DEST)/philosophy/Index/index.html : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl

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
					 $(filter $(T2_DEST)/wysiwyt.html,$(T2_DOCS_DEST)) \
					 $(filter $(T2_DEST)/wonderous.html,$(T2_DOCS_DEST))

$(T2_HUMOUR_DOCS_DEST): $(HUMOUR_DEPS)

VIPE_HUMOUR_DOCS_SRC = 

$(VIPE_HUMOUR_DOCS_SRC): $(VIPE_SRC_DIR)/%.wml: $(HUMOUR_DEPS)
	touch $@


T2_PUZZLES_DOCS_SRC = $(filter $(T2_SRC_DIR)/puzzles/%,$(T2_DOCS_SRC)) $(filter $(T2_SRC_DIR)/MathVentures/%,$(T2_DOCS_SRC))

$(T2_PUZZLES_DOCS_SRC): $(T2_SRC_DIR)/%.wml: $(PUZZLES_DEPS)
	touch $@

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

$(PROD_SYND_MUSIC_INC) : $(PROD_SYND_MUSIC_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/art/recommendations/music/shlomi-fish-music-recommendations.xml
	perl $<
	./gen-helpers.pl
	$(MAKE)

$(T2_DEST)/philosophy/books-recommends/index.html : $(PROD_SYND_NON_FICTION_BOOKS_INC)

$(PROD_SYND_NON_FICTION_BOOKS_INC) : $(PROD_SYND_NON_FICTION_BOOKS_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/philosophy/books-recommends/shlomi-fish-non-fiction-books-recommendations.xml
	perl $<
	./gen-helpers.pl
	$(MAKE)

$(T2_DEST)/humour/recommendations/films/index.html: $(PROD_SYND_FILMS_INC)

$(PROD_SYND_FILMS_INC) : $(PROD_SYND_FILMS_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/humour/recommendations/films/shlomi-fish-films-recommendations.xml
	perl $<
	./gen-helpers.pl
	$(MAKE)


$(SITE_SOURCE_INSTALL_TARGET): INSTALL
	cp -f $< $@

SCREENPLAY_DOCS = \
    Blue-Rabbit-Log-Part-1 \
	Humanity-Movie \
	ae-interview \
	hitchhikers-guide-to-star-trek-tng \
	star-trek--we-the-living-dead \
	sussman-interview \
	TOW_Fountainhead_1  \
	TOW_Fountainhead_2

FICTION_DOCS = \
	The-Enemy-Hebrew-rev6 \
	The-Pope-Died-on-Sunday-hebrew

DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS_CSS = $(patsubst %,%/style.css,$(DOCBOOK4_INDIVIDUAL_XHTMLS))
DOCBOOK4_INSTALLED_CSS_DIRS = $(foreach doc,$(DOCBOOK4_DOCS),$(T2_DEST)/$(call get,DOCBOOK4_DIRS_MAP,$(doc))/docbook-css)
DOCMAKE_STYLE_CSS = $(DOCMAKE_XSLT_PATH)/style.css

DOCBOOK4_BASE_DIR = lib/docbook
DOCBOOK4_RENDERED_DIR = $(DOCBOOK4_BASE_DIR)/rendered
DOCBOOK4_ALL_IN_ONE_XHTML_DIR = $(DOCBOOK4_BASE_DIR)/essays

SCREENPLAY_XML_BASE_DIR = lib/screenplay-xml
SCREENPLAY_XML_XML_DIR = $(SCREENPLAY_XML_BASE_DIR)/xml
SCREENPLAY_XML_TXT_DIR = $(SCREENPLAY_XML_BASE_DIR)/txt
SCREENPLAY_XML_HTML_DIR = $(SCREENPLAY_XML_BASE_DIR)/html
SCREENPLAY_XML_RENDERED_HTML_DIR = $(SCREENPLAY_XML_BASE_DIR)/rendered-html

FICTION_XML_BASE_DIR = lib/fiction-xml
FICTION_XML_XML_DIR = $(FICTION_XML_BASE_DIR)/xml
FICTION_XML_TXT_DIR = $(FICTION_XML_BASE_DIR)/txt

DOCBOOK5_BASE_DIR = lib/docbook/5
DOCBOOK5_ALL_IN_ONE_XHTML_DIR = $(DOCBOOK5_BASE_DIR)/essays
DOCBOOK5_SOURCES_DIR = $(DOCBOOK5_BASE_DIR)/xml
DOCBOOK5_FO_DIR = $(DOCBOOK5_BASE_DIR)/fo
DOCBOOK5_PDF_DIR = $(DOCBOOK5_BASE_DIR)/pdf
DOCBOOK5_RTF_DIR = $(DOCBOOK5_BASE_DIR)/rtf
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

DOCBOOK5_PDFS = $(patsubst %,$(DOCBOOK5_PDF_DIR)/%.pdf,$(DOCBOOK5_DOCS))

DOCBOOK5_RTFS = $(patsubst %,$(DOCBOOK5_RTF_DIR)/%.rtf,$(DOCBOOK5_DOCS))

DOCBOOK5_INDIVIDUAL_XHTMLS = $(patsubst %,$(DOCBOOK5_INDIVIDUAL_XHTML_DIR)/%,$(DOCBOOK5_DOCS))

DOCBOOK5_ALL_IN_ONE_XHTMLS = $(patsubst %,$(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml,$(DOCBOOK5_DOCS))


SCREENPLAY_RENDERED_HTMLS = $(patsubst %,$(SCREENPLAY_XML_RENDERED_HTML_DIR)/%.html,$(SCREENPLAY_DOCS))

$(SCREENPLAY_XML_HTML_DIR)/%.html: $(SCREENPLAY_XML_XML_DIR)/%.xml
	perl -MXML::Grammar::Screenplay::App::ToHTML -e 'run()' -- \
	-o $@ $<

$(SCREENPLAY_XML_RENDERED_HTML_DIR)/%.html: $(SCREENPLAY_XML_HTML_DIR)/%.html
	./bin/extract-screenplay-xml-html.pl -o $@ $<

$(SCREENPLAY_XML_XML_DIR)/%.xml: $(SCREENPLAY_XML_TXT_DIR)/%.txt
	perl -MXML::Grammar::Screenplay::App::FromProto -e 'run()' -- \
	-o $@ $<

SCREENPLAY_SOURCES_ON_DEST = $(T2_DEST)/humour/TOWTF/TOW_Fountainhead_1.txt $(T2_DEST)/humour/TOWTF/TOW_Fountainhead_2.txt $(T2_DEST)/humour/humanity/Humanity-Movie.txt $(T2_DEST)/humour/Star-Trek/We-the-Living-Dead/star-trek--we-the-living-dead.txt $(T2_DEST)/open-source/interviews/ae-interview.txt $(T2_DEST)/open-source/interviews/sussman-interview.txt $(T2_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-Part-1.txt

FICTION_TEXT_SOURCES_ON_DEST = $(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-hebrew.txt

docbook_extended: $(DOCBOOK4_FOS) $(DOCBOOK4_PDFS) \
	install_docbook4_pdfs install_docbook4_rtfs \
	install_docbook5_pdfs install_docbook5_rtfs 

docbook_indiv: $(DOCBOOK4_INDIVIDUAL_XHTMLS)

screenplay_targets: $(ST_WTLD_TEXT_IN_TREE) $(SCREENPLAY_XMLS) $(SCREENPLAY_HTMLS) $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_SOURCES_ON_DEST) $(FICTION_TEXT_SOURCES_ON_DEST)

docbook_targets: docbook4_targets screenplay_targets docbook5_targets \
	install_docbook4_xmls install_docbook_individual_xhtmls install_docbook_css_dirs docbook_hhfg_images docbook5_targets install_docbook5_xmls

docbook4_targets: $(DOCBOOK4_TARGETS) $(DOCBOOK4_ALL_IN_ONE_XHTMLS) $(DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS)

docbook5_targets: $(DOCBOOK5_TARGETS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS_CSS)

$(FICTION_DB5S): $(DOCBOOK5_XML_DIR)/%.xml: $(FICTION_XML_XML_DIR)/%.xml 
	perl -MXML::Grammar::Fiction::App::ToDocBook -e 'run()' -- \
		-o $@ $<

$(FICTION_XMLS): $(FICTION_XML_XML_DIR)/%.xml: $(FICTION_XML_TXT_DIR)/%.txt
	perl -MXML::Grammar::Fiction::App::FromProto -e 'run()' -- \
	-o $@ $<


$(DOCBOOK4_RENDERED_DIR)/%.html: $(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html
	./bin/clean-up-docbook-xsl-xhtml.pl -o $@ $<

$(DOCBOOK4_FO_DIR)/%.fo: $(DOCBOOK4_XML_DIR)/%.xml
	$(DOCMAKE_WITH_PARAMS) -o $@ --stringparam "docmake.output.format=fo" -x $(FO_XSLT_SS) fo $<


$(DOCBOOK4_PDF_DIR)/%.pdf: $(DOCBOOK4_FO_DIR)/%.fo
	fop -fo $< -pdf $@

$(DOCBOOK4_RTF_DIR)/%.rtf: $(DOCBOOK4_FO_DIR)/%.fo
	fop -fo $< -rtf $@

DOCMAKE_SGML_PATH = lib/sgml/shlomif-docbook
DOCBOOK4_MAK_MAKEFILES_PATH = lib/make/docbook

include $(DOCBOOK4_MAK_MAKEFILES_PATH)/docbook-render.mak

DOCMAKE_PARAMS = -v

$(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html: $(DOCBOOK4_XML_DIR)/%.xml
	$(DOCMAKE) --stringparam "docmake.output.format=xhtml" -x $(XHTML_ONE_CHUNK_XSLT_SS) -o $(patsubst $(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html,$(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%,$@) xhtml $<
	mv $(patsubst %/all-in-one.html,%/index.html,$@) $@

HHGG_CONVERT_SCRIPT_FN = convert-hitchhiker-guide-to-st-tng-to-screenplay-xml.pl
HHGG_CONVERT_SCRIPT_SRC = bin/processors/$(HHGG_CONVERT_SCRIPT_FN)
HHGG_CONVERT_SCRIPT_DEST = $(T2_DEST)/humour/by-others/$(HHGG_CONVERT_SCRIPT_FN).txt

$(HHGG_CONVERT_SCRIPT_DEST): $(HHGG_CONVERT_SCRIPT_SRC)
	cp -f $< $@
	
hhgg_convert: $(HHGG_CONVERT_SCRIPT_DEST)

$(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng.txt : $(HHGG_CONVERT_SCRIPT_SRC) t2/humour/by-others/hitchhiker-guide-to-star-trek-tng.txt
	perl $<

$(T2_DEST)/humour/TOWTF/TOW_Fountainhead_1.txt: $(SCREENPLAY_XML_TXT_DIR)/TOW_Fountainhead_1.txt
	cp -f $< $@

$(T2_DEST)/humour/TOWTF/TOW_Fountainhead_2.txt: $(SCREENPLAY_XML_TXT_DIR)/TOW_Fountainhead_2.txt
	cp -f $< $@

$(T2_DEST)/humour/humanity/Humanity-Movie.txt: $(SCREENPLAY_XML_TXT_DIR)/Humanity-Movie.txt
	cp -f $< $@

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday-hebrew.txt: $(FICTION_XML_TXT_DIR)/The-Pope-Died-on-Sunday-hebrew.txt
	cp -f $< $@

# Rebuild the embedded screenplays pages in the $(T2_DEST) after they are
# modified.
$(T2_DEST)/humour/Blue-Rabbit-Log/part-1.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/Blue-Rabbit-Log-Part-1.html
$(T2_DEST)/humour/humanity/ongoing-text.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/Humanity-Movie.html
$(T2_DEST)/humour/Star-Trek/We-the-Living-Dead/ongoing-text.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/star-trek--we-the-living-dead.html
$(T2_DEST)/humour/TOWTF/TOW_Fountainhead_1.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/TOW_Fountainhead_1.html
$(T2_DEST)/humour/by-others/hitchhiker-guide-to-star-trek-tng-htmlised.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/hitchhikers-guide-to-star-trek-tng.html
$(T2_DEST)/humour/TOWTF/TOW_Fountainhead_2.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/TOW_Fountainhead_2.html
$(T2_DEST)/open-source/interviews/adrian-ettlinger.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/ae-interview.html
$(T2_DEST)/open-source/interviews/sussman.html: $(SCREENPLAY_XML_RENDERED_HTML_DIR)/sussman-interview.html

# Rebuild the embedded docbook4 pages in the $(T2_DEST) after they are 
# modified.

$(T2_DEST)/philosophy/computers/education/introductory-language/index.html: $(DOCBOOK4_RENDERED_DIR)/introductory-language.html

# Rebuild the embedded docbook5 pages in the $(T2_DEST) after they are 
# modified.

$(T2_DEST)/philosophy/psychology/hypomanias/index.html: $(DOCBOOK5_RENDERED_DIR)/dealing-with-hypomanias.xhtml

$(T2_DEST)/philosophy/politics/drug-legalisation/index.html: $(DOCBOOK5_RENDERED_DIR)/case-for-drug-legalisation-rev2.xhtml

$(T2_DEST)/philosophy/computers/open-source/foss-licences-wars/index.html : $(DOCBOOK4_RENDERED_DIR)/foss-licences-wars.html

$(T2_DEST)/philosophy/obj-oss/rev2/index.html: $(DOCBOOK5_RENDERED_DIR)/objectivism-and-open-source.xhtml

$(T2_DEST)/open-source/projects/Spark/mission/Spark-Pre-Birth-of-a-Modern-Lisp/index.html : $(DOCBOOK4_RENDERED_DIR)/Spark-Pre-Birth-of-a-Modern-Lisp.html

# Rebuild the pages containing the links to t2/humour/stories upon changing
# the lib/stories.

$(T2_DEST)/humour/index.html: lib/stories/stories-list.wml
$(T2_DEST)/humour/stories/index.html: lib/stories/stories-list.wml

$(T2_DEST)/philosophy/computers/software-management/perfect-workplace/rev2/content.html: $(DOCBOOK5_RENDERED_DIR)/perfect-it-workplace-rev2.xhtml

$(T2_DEST)/humour/Blue-Rabbit-Log/Blue-Rabbit-Log-Part-1.txt: $(SCREENPLAY_XML_TXT_DIR)/Blue-Rabbit-Log-Part-1.txt
	cp -f $< $@

$(T2_DEST)/humour/Star-Trek/We-the-Living-Dead/star-trek--we-the-living-dead.txt: $(SCREENPLAY_XML_TXT_DIR)/star-trek--we-the-living-dead.txt
	cp -f $< $@

$(T2_DEST)/open-source/interviews/ae-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/ae-interview.txt
	cp -f $< $@

$(T2_DEST)/open-source/interviews/sussman-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/sussman-interview.txt
	cp -f $< $@

$(T2_DEST)/humour/Pope/The-Pope-Died-on-Sunday--Hebrew-Text.html: lib/docbook/5/rendered/The-Pope-Died-on-Sunday-hebrew.xhtml

$(T2_DEST)/humour/TheEnemy/The-Enemy-rev6.html: lib/docbook/5/rendered/The-Enemy-Hebrew-rev6.xhtml

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
	rsync -r -v $< $@
	find $@ -name '.svn' -print0 | xargs -0 rm -fr

FORTUNES_XHTMLS_DIR = lib/fortunes/xhtmls

FORTUNES_XMLS_BASE = $(addsuffix .xml,$(FORTUNES_FILES_BASE))
FORTUNES_XMLS_SRC = $(patsubst %,$(T2_FORTUNES_DIR)/%,$(FORTUNES_XMLS_BASE))
FORTUNES_XHTMLS = $(patsubst $(T2_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_TEXTS = $(patsubst %.xml,%,$(FORTUNES_XMLS_SRC))
FORTUNES_ATOM_FEED = $(T2_FORTUNES_DIR)/fortunes-shlomif-all.atom
FORTUNES_RSS_FEED = $(T2_FORTUNES_DIR)/fortunes-shlomif-all.rss

fortunes-compile-xmls: $(FORTUNES_XHTMLS) $(FORTUNES_TEXTS) $(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED) 

# The touch is to make sure we compile the .html.wml again.

$(FORTUNES_XHTMLS): $(FORTUNES_XHTMLS_DIR)/%.xhtml : $(T2_FORTUNES_DIR)/%.xml
	bash $(T2_FORTUNES_DIR)/run-validator.bash $< && \
	perl $(T2_FORTUNES_DIR)/convert-to-xhtml.pl $< $@ && \
	touch $(patsubst %.xml,%.html.wml,$<)

$(FORTUNES_TEXTS): $(T2_FORTUNES_DIR)/%: $(T2_FORTUNES_DIR)/%.xml
	bash $(T2_FORTUNES_DIR)/run-validator.bash $< && \
	perl $(T2_FORTUNES_DIR)/convert-to-plaintext.pl $< $@

$(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED): $(T2_FORTUNES_DIR)/generate-web-feeds.pl $(FORTUNES_XMLS_SRC)
	perl $< --atom $(FORTUNES_ATOM_FEED) --rss $(FORTUNES_RSS_FEED) --dir $(T2_FORTUNES_DIR)

$(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS_CSS): %: $(DOCMAKE_STYLE_CSS)
	cp -f $< $@

$(DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS): %: $(DOCMAKE_STYLE_CSS)
	cp -f $< $@

COMMON_CSSS = lib/common-style.css.ttml lib/newsitem.css.ttml lib/smoked-wp-theme.css.ttml lib/lang_switch.css.ttml

common/style.css.ttml: $(COMMON_CSSS)
	touch $@

common/style-2008.css.ttml: $(COMMON_CSSS)
	touch $@


MOJOLICIOUS_LECTURE_SLIDE1 = $(T2_DEST)/lecture/Perl/Lightning/Mojolicious/mojolicious-slides.html

mojo_pres: $(MOJOLICIOUS_LECTURE_SLIDE1)

$(MOJOLICIOUS_LECTURE_SLIDE1): t2/lecture/Perl/Lightning/Mojolicious/mojolicious.asciidoc.txt
	asciidoc -o $@ $<

lib/docbook/xml/Spark-Pre-Birth-of-a-Modern-Lisp.xml: t2/open-source/projects/Spark/mission/Spark-Pre-Birth-of-a-Modern-Lisp.txt
	asciidoc --backend=docbook -o $@ $<

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

DOCBOOK5_XSL_STYLESHEETS_XHTML_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/xhtml
DOCBOOK5_XSL_STYLESHEETS_ONECHUNK_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/onechunk
DOCBOOK5_XSL_STYLESHEETS_FO_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/fo

DOCBOOK5_XSL_CUSTOM_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-xhtml.xsl
DOCBOOK5_XSL_ONECHUNK_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-xhtml-onechunk.xsl
DOCBOOK5_XSL_FO_XSLT_STYLESHEET := lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-fo.xsl

DOCBOOK5_DOCS = \
	case-for-drug-legalisation-rev2 \
	dealing-with-hypomanias \
	perfect-it-workplace-rev2 \
	objectivism-and-open-source \
	foss-and-other-beasts-v3 \
	foss-licences-wars-rev2 \
	human-hacking-field-guide-v2 \
	$(FICTION_DOCS)

# DOCBOOK4_BASE_DIR = lib/docbook
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

docbook5_targets: $(DOCBOOK5_RENDERED_HTMLS) $(DOCBOOK5_FOS)





$(DOCBOOK4_RENDERED_DIR)/%.html: $(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html
	./bin/clean-up-docbook-xsl-xhtml.pl -o $@ $<

$(DOCBOOK4_FO_DIR)/%.fo: $(DOCBOOK4_XML_DIR)/%.xml
	$(DOCMAKE_WITH_PARAMS) -o $@ --stringparam "docmake.output.format=fo" -x $(FO_XSLT_SS) fo $<

$(DOCBOOK4_PDF_DIR)/%.pdf: $(DOCBOOK4_FO_DIR)/%.fo
	fop -fo $< -pdf $@

$(DOCBOOK4_RTF_DIR)/%.rtf: $(DOCBOOK4_FO_DIR)/%.fo
	fop -fo $< -rtf $@

$(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html: $(DOCBOOK4_XML_DIR)/%.xml
	$(DOCMAKE) --stringparam "docmake.output.format=xhtml" -x $(XHTML_ONE_CHUNK_XSLT_SS) -o $(patsubst $(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html,$(DOCBOOK4_ALL_IN_ONE_XHTML_DIR)/%,$@) xhtml $<
	mv $(patsubst %/all-in-one.html,%/index.html,$@) $@


$(DOCBOOK5_ALL_IN_ONE_XHTMLS): $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml: $(DOCBOOK5_SOURCES_DIR)/%.xml
	jing http://www.docbook.org/xml/5.0/rng/docbook.rng $<
	xsltproc --stringparam root.filename $@ --path  $(DOCBOOK5_XSL_STYLESHEETS_XHTML_PATH) $(DOCBOOK5_XSL_ONECHUNK_XSLT_STYLESHEET) $<
	mv -f $@.html $@

$(DOCBOOK5_RENDERED_DIR)/%.xhtml: $(DOCBOOK5_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.xhtml
	./bin/clean-up-docbook-5-xsl-xhtml-1_1.pl -o $@ $<

$(DOCBOOK5_FO_DIR)/%.fo: $(DOCBOOK5_SOURCES_DIR)/%.xml
	xsltproc --path $(DOCBOOK5_XSL_STYLESHEETS_FO_PATH) -o $@ $(DOCBOOK5_XSL_FO_XSLT_STYLESHEET) $<

$(DOCBOOK5_PDF_DIR)/%.pdf: $(DOCBOOK5_FO_DIR)/%.fo
	fop -fo $< -pdf $@

$(DOCBOOK5_RTF_DIR)/%.rtf: $(DOCBOOK5_FO_DIR)/%.fo
	fop -fo $< -rtf $@

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
	(cd $(patsubst %/slides/start.html,%,$@) ; \
		shspork -make ; \
		(cd slides/ && (for I in *.html ; do tidy -asxhtml -o "$$I".new "$$I" ; mv -f "$$I".new "$$I" ; done)) \
	)

lib/presentations/spork/Vim/beginners/Spork.slides: lib/presentations/spork/Vim/beginners/Spork.slides.source
	cat $< | perl -pe 's!^\+!!' > $@

GEN_STYLE_CSS_FILES = style.css style-2008.css

T2_CSS_TARGETS = $(patsubst %,$(T2_DEST)/%,$(GEN_STYLE_CSS_FILES))
VIPE_CSS_TARGETS = $(patsubst %,$(VIPE_DEST)/%,$(GEN_STYLE_CSS_FILES))

CSS_GEN_SCRIPT = bin/gen-css.pl

CSS_TARGETS_COMMON_DEPS = $(TTMLS_COMMON_DEPS) $(CSS_GEN_SCRIPT)

css_targets: $(T2_CSS_TARGETS) $(VIPE_CSS_TARGETS)

$(T2_CSS_TARGETS) : $(T2_DEST)/% : lib/%.ttml $(CSS_TARGETS_COMMON_DEPS)
	perl $(CSS_GEN_SCRIPT) -o $@ $(T2_TTML_FLAGS) -DLATEMP_FILENAME=$(patsubst $(T2_DEST)/%,%,$(patsubst %.ttml,%,$@)) $<

$(VIPE_CSS_TARGETS) : $(VIPE_DEST)/% : lib/%.ttml $(CSS_TARGETS_COMMON_DEPS)
	perl $(CSS_GEN_SCRIPT) -o $@ $(VIPE_TTML_FLAGS) -DLATEMP_FILENAME=$(patsubst $(VIPE_DEST)/%,%,$(patsubst %.ttml,%,$@)) $<

