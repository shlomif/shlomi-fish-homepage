LATEMP_WML_FLAGS =$(shell latemp-config --wml-flags)

COMMON_PREPROC_FLAGS = -I $$HOME/conf/wml/Latemp/lib 
WML_FLAGS += --passoption=2,-X3074 --passoption=3,-I../lib/ \
	--passoption=3,-w -I../lib/ $(LATEMP_WML_FLAGS) \
	-DROOT~. -DLATEMP_THEME=better-scm \
	-I $${HOME}/apps/wml

TTML_FLAGS += $(COMMON_PREPROC_FLAGS) -I lib
WML_FLAGS += $(COMMON_PREPROC_FLAGS)

ALL_DEST_BASE = dest


DOCS_COMMON_DEPS = template.wml lib/MyNavData.pm

all: make-dirs docbook_targets latemp_targets fortunes-target sitemap_targets copy_fortunes site-source-install

include lib/make/gmsl/gmsl
	
include include.mak
include rules.mak

make-dirs: $(T2_DIRS_DEST) 

FORTUNES_DIR = humour/fortunes
T2_FORTUNES_DIR = t2/$(FORTUNES_DIR)

include $(T2_FORTUNES_DIR)/arcs-list.mak
include $(T2_FORTUNES_DIR)/fortunes-list.mak

SITE_SOURCE_INSTALL_TARGET = $(T2_DEST)/meta/site-source/INSTALL
FORTUNES_TARGET =  $(T2_DEST)/$(FORTUNES_DIR)/index.html

site-source-install: $(SITE_SOURCE_INSTALL_TARGET)

fortunes-target: $(FORTUNES_TARGET) fortunes-compile-xmls

# t2 macros

RSYNC = rsync --progress --verbose --rsh=ssh

T2_DEST_FORTUNES = $(patsubst %,$(T2_DEST)/$(FORTUNES_DIR)/%,$(FORTUNES_ARCS_LIST))

copy_fortunes: $(T2_DEST_FORTUNES)

$(T2_DEST_FORTUNES) :: $(T2_DEST)/% : t2/%
	cp -f $< $@

upload_deps: all

upload: upload_deps
	( cd $(T2_DEST) && $(RSYNC) -a * $${HOMEPAGE_SSH_PATH}/ )

upload_backup: upload_deps
	( cd $(T2_DEST) && $(RSYNC) -r * shlomif@alberni.textdrive.com:domains/www-backup.shlomifish.org/web/public )

upload_remote: upload upload_remote_only

upload_remote_only: upload_deps
	( cd $(T2_DEST) && $(RSYNC) -a * $${__HOMEPAGE_REMOTE_PATH}/ )

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

$(FORTUNES_TARGET): $(T2_FORTUNES_DIR)/index.html.wml $(DOCS_COMMON_DEPS) $(HUMOUR_DEPS) $(T2_FORTUNES_DIR)/Makefile
	WML_LATEMP_PATH="$$(perl -MFile::Spec -e 'print File::Spec->rel2abs(shift)' '$@')" ; ( cd $(T2_SRC_DIR) && wml -o "$${WML_LATEMP_PATH}" $(T2_WML_FLAGS) -DLATEMP_FILENAME=$(patsubst $(T2_DEST)/%,%,$(patsubst %.wml,%,$@)) -DPACKAGE_BASE="$$( unset MAKELEVEL ; cd $(FORTUNES_DIR) && make print_package_base )" $(patsubst $(T2_SRC_DIR)/%,%,$<) )


T2_DOCS_SRC = $(patsubst $(T2_DEST)/%,$(T2_SRC_DIR)/%.wml,$(T2_DOCS_DEST))
VIPE_DOCS_SRC = $(patsubst $(VIPE_DEST)/%,$(VIPE_SRC_DIR)/%.wml,$(VIPE_DOCS_DEST))

T2_PHILOSOPHY_DOCS_SRC = $(filter-out $(T2_SRC_DIR)/philosophy/books-recommends/%,$(filter-out $(T2_SRC_DIR)/philosophy/Index/%,$(filter $(T2_SRC_DIR)/philosophy/%,$(T2_DOCS_SRC))) $(filter $(T2_SRC_DIR)/prog-evolution/%,$(T2_DOCS_SRC)))

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
					   $(filter $(T2_SRC_DIR)/no-ie/%,$(T2_DOCS_SRC)) \
					   $(filter $(T2_SRC_DIR)/rindolf/%,$(T2_DOCS_SRC))

$(T2_SOFTWARE_DOCS_SRC):: $(T2_SRC_DIR)/%.wml: $(SOFTWARE_DEPS)
	touch $@

VIPE_SOFTWARE_DOCS_SRC = $(filter $(VIPE_SRC_DIR)/rwlock/%,$(VIPE_DOCS_SRC)) \
						 $(filter $(VIPE_SRC_DIR)/software-tools/%,$(VIPE_DOCS_SRC))

$(VIPE_SOFTWARE_DOCS_SRC):: $(VIPE_SRC_DIR)/%.wml: $(SOFTWARE_DEPS)
	touch $@


#### Humour thing

T2_HUMOUR_DOCS_SRC = $(filter-out $(T2_SRC_DIR)/humour/recommendations/%,$(filter $(T2_SRC_DIR)/humour/%,$(T2_DOCS_SRC))) \
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
	perl ./bin/fetch-shlomif_hsite-feed.pl
	touch t2/index.html.wml
	touch t2/old-news.html.wml

T2_SITEMAP_FILE = $(T2_DEST)/sitemap.xml.gz

sitemap_targets: $(T2_SITEMAP_FILE)

$(T2_SITEMAP_FILE): bin/gen-google-site-map.pl
	perl $<

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

$(T2_SRC_DIR)/philosophy/books-recommends/index.html.wml : $(PROD_SYND_NON_FICTION_BOOKS_INC)
	touch $@

$(PROD_SYND_NON_FICTION_BOOKS_INC) : $(PROD_SYND_NON_FICTION_BOOKS_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/philosophy/books-recommends/shlomi-fish-non-fiction-books-recommendations.xml
	perl $<
	./gen-helpers.pl
	$(MAKE)

$(T2_SRC_DIR)/humour/recommendations/films/index.html.wml: $(PROD_SYND_FILMS_INC)
	touch $@

$(PROD_SYND_FILMS_INC) : $(PROD_SYND_FILMS_DIR)/gen-prod-synd.pl $(T2_SRC_DIR)/humour/recommendations/films/shlomi-fish-films-recommendations.xml
	perl $<
	./gen-helpers.pl
	$(MAKE)


$(SITE_SOURCE_INSTALL_TARGET): INSTALL
	cp -f $< $@

SCREENPLAY_DOCS = \
	Humanity-Movie \
	ae-interview \
	star-trek--we-the-living-dead \
	TOW_Fountainhead_1  \
	TOW_Fountainhead_2

$(call set,DOCBOOK_DIRS_MAP,case-for-drug-legalisation,philosophy/politics/drug-legalisation)
$(call set,DOCBOOK_DIRS_MAP,case-for-file-swapping-rev3,philosophy/case-for-file-swapping/revision-3)
$(call set,DOCBOOK_DIRS_MAP,dealing-with-hypomanias,philosophy/psychology/hypomanias/)
$(call set,DOCBOOK_DIRS_MAP,end-of-it-slavery,philosophy/computers/software-management/end-of-it-slavery)
$(call set,DOCBOOK_DIRS_MAP,foss-and-other-beasts,philosophy/foss-other-beasts/revision-2)
$(call set,DOCBOOK_DIRS_MAP,introductory-language,philosophy/computers/education/introductory-language)
$(call set,DOCBOOK_DIRS_MAP,isr-pales-conflict-solution,philosophy/israel-pales)
$(call set,DOCBOOK_DIRS_MAP,objectivism-and-open-source,philosophy/obj-oss)
$(call set,DOCBOOK_DIRS_MAP,rindolf-spec,rindolf)
$(call set,DOCBOOK_DIRS_MAP,the-eternal-jew,philosophy/the-eternal-jew)
$(call set,DOCBOOK_DIRS_MAP,what-makes-software-high-quality,philosophy/computers/high-quality-software)
$(call set,DOCBOOK_DIRS_MAP,what-makes-software-high-quality-rev2,philosophy/computers/high-quality-software/rev2)
$(call set,DOCBOOK_DIRS_MAP,perfect-it-workplace,philosophy/computers/software-management/perfect-workplace)
$(call set,DOCBOOK_DIRS_MAP,foss-licences-war,philosophy/computers/open-source/foss-licences-war)

DOCBOOK_DOCS = $(call keys,DOCBOOK_DIRS_MAP)

DOCBOOK_INSTALLED_PDFS = $(foreach doc,$(DOCBOOK_DOCS),$(T2_DEST)/$(call get,DOCBOOK_DIRS_MAP,$(doc))/$(doc).pdf)
DOCBOOK_INSTALLED_XMLS = $(foreach doc,$(DOCBOOK_DOCS),$(T2_DEST)/$(call get,DOCBOOK_DIRS_MAP,$(doc))/$(doc).xml)
DOCBOOK_INSTALLED_RTFS = $(foreach doc,$(DOCBOOK_DOCS),$(T2_DEST)/$(call get,DOCBOOK_DIRS_MAP,$(doc))/$(doc).rtf)
DOCBOOK_INSTALLED_INDIVIDUAL_XHTMLS = $(foreach doc,$(DOCBOOK_DOCS),$(T2_DEST)/$(call get,DOCBOOK_DIRS_MAP,$(doc))/$(doc))
DOCBOOK_INSTALLED_INDIVIDUAL_XHTMLS_CSS = $(patsubst %,%/style.css,$(DOCBOOK_INDIVIDUAL_XHTMLS))
DOCBOOK_INSTALLED_CSS_DIRS = $(foreach doc,$(DOCBOOK_DOCS),$(T2_DEST)/$(call get,DOCBOOK_DIRS_MAP,$(doc))/docbook-css)
DOCMAKE_STYLE_CSS = $(DOCMAKE_XSLT_PATH)/style.css

# DOCBOOK_DOCS = \
# 	case-for-drug-legalisation \
# 	case-for-file-swapping-rev3 \
# 	end-of-it-slavery \
# 	introductory-language \
# 	objectivism-and-open-source \
# 	what-makes-software-high-quality

#   Removing, because we no longer need to build the DocBook.
#   $(SCREENPLAY_DOCS)

DOCBOOK_XML_DIR = lib/docbook/xml
DOCBOOK_FO_DIR = lib/docbook/fo
DOCBOOK_PDF_DIR = lib/docbook/pdf
DOCBOOK_RTF_DIR = lib/docbook/rtf
DOCBOOK_RENDERED_DIR = lib/docbook/rendered
DOCBOOK_INDIVIDUAL_XHTML_DIR = lib/docbook/indiv-nodes
DOCBOOK_ALL_IN_ONE_XHTML_DIR = lib/docbook/essays

DOCBOOK_TARGETS = $(patsubst %,$(DOCBOOK_RENDERED_DIR)/%.html,$(DOCBOOK_DOCS))
DOCBOOK_XMLS = $(patsubst %,$(DOCBOOK_XML_DIR)/%.xml,$(DOCBOOK_DOCS))
SCREENPLAY_XMLS = $(patsubst %,lib/screenplay-xml/xml/%.xml,$(SCREENPLAY_DOCS))
SCREENPLAY_HTMLS = $(patsubst %,lib/screenplay-xml/html/%.html,$(SCREENPLAY_DOCS))

DOCBOOK_FOS = $(patsubst %,$(DOCBOOK_FO_DIR)/%.fo,$(DOCBOOK_DOCS))

DOCBOOK_PDFS = $(patsubst %,$(DOCBOOK_PDF_DIR)/%.pdf,$(DOCBOOK_DOCS))

DOCBOOK_RTFS = $(patsubst %,$(DOCBOOK_RTF_DIR)/%.rtf,$(DOCBOOK_DOCS))

DOCBOOK_INDIVIDUAL_XHTMLS = $(patsubst %,$(DOCBOOK_INDIVIDUAL_XHTML_DIR)/%,$(DOCBOOK_DOCS))

DOCBOOK_ALL_IN_ONE_XHTMLS = $(patsubst %,$(DOCBOOK_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html,$(DOCBOOK_DOCS))

SCREENPLAY_RENDERED_HTMLS = $(patsubst %,lib/screenplay-xml/rendered-html/%.html,$(SCREENPLAY_DOCS))

$(DOCBOOK_XML_DIR)/%.xml: lib/screenplay-xml/xml/%.xml
	perl -MXML::Grammar::Screenplay::App::ToDocBook -e 'run()' -- \
	-o $@ $<

lib/screenplay-xml/html/%.html: lib/screenplay-xml/xml/%.xml
	perl -MXML::Grammar::Screenplay::App::ToHTML -e 'run()' -- \
	-o $@ $<

lib/screenplay-xml/rendered-html/%.html: lib/screenplay-xml/html/%.html
	./bin/extract-screenplay-xml-html.pl -o $@ $<

lib/screenplay-xml/xml/%.xml: lib/screenplay-xml/txt/%.txt
	perl -MXML::Grammar::Screenplay::App::FromProto -e 'run()' -- \
	-o $@ $<

SCREENPLAY_TARGETS = $(patsubst %,$(DOCBOOK_RENDERED_DIR)/%.html,$(SCREEPLAY_DOCS))

SCREENPLAY_SOURCES_ON_DEST = $(T2_DEST)/humour/TOWTF/TOW_Fountainhead_1.txt $(T2_DEST)/humour/TOWTF/TOW_Fountainhead_2.txt $(T2_DEST)/humour/humanity/Humanity-Movie.txt $(T2_DEST)/humour/Star-Trek/We-the-Living-Dead/star-trek--we-the-living-dead.txt

docbook_extended: $(DOCBOOK_FOS) $(DOCBOOK_PDFS) install_docbook_pdfs install_docbook_rtfs 

docbook_targets: $(DOCBOOK_TARGETS) $(DOCBOOK_ALL_IN_ONE_XHTMLS) $(ST_WTLD_TEXT_IN_TREE) $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_SOURCES_ON_DEST) install_docbook_xmls install_docbook_individual_xhtmls install_docbook_css_dirs

$(DOCBOOK_RENDERED_DIR)/%.html: $(DOCBOOK_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html
	./bin/clean-up-docbook-xsl-xhtml.pl -o $@ $<

$(DOCBOOK_FO_DIR)/%.fo: $(DOCBOOK_XML_DIR)/%.xml
	$(DOCMAKE_WITH_PARAMS) -o $@ --stringparam "docmake.output.format=fo" -x $(FO_XSLT_SS) fo $<

$(DOCBOOK_PDF_DIR)/%.pdf: $(DOCBOOK_FO_DIR)/%.fo
	fop -fo $< -pdf $@

$(DOCBOOK_RTF_DIR)/%.rtf: $(DOCBOOK_FO_DIR)/%.fo
	fop -fo $< -rtf $@

$(DOCBOOK_INDIVIDUAL_XHTML_DIR)/%: $(DOCBOOK_XML_DIR)/%.xml $(XSL_SOURCES)
	$(DOCMAKE_WITH_PARAMS) --stringparam "docmake.output.format=xhtml" --stringparam "docmake.output.path_to_root="$(shell perl -e '$$_=shift;$$c=tr[/][];print "../"x($$c+2)' $(call get,DOCBOOK_DIRS_MAP,$(patsubst $(DOCBOOK_INDIVIDUAL_XHTML_DIR)/%,%,$@))) -x $(XHTML_XSLT_SS) -o $@ xhtml $<
	touch $@

DOCMAKE_SGML_PATH = lib/sgml/shlomif-docbook
DOCBOOK_MAK_MAKEFILES_PATH = lib/make/docbook

include $(DOCBOOK_MAK_MAKEFILES_PATH)/docbook-render.mak

DOCMAKE_PARAMS = -v

$(DOCBOOK_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html: $(DOCBOOK_XML_DIR)/%.xml
	$(DOCMAKE) --stringparam "docmake.output.format=xhtml" -x $(XHTML_ONE_CHUNK_XSLT_SS) -o $(patsubst $(DOCBOOK_ALL_IN_ONE_XHTML_DIR)/%/all-in-one.html,$(DOCBOOK_ALL_IN_ONE_XHTML_DIR)/%,$@) xhtml $<
	mv $(patsubst %/all-in-one.html,%/index.html,$@) $@

$(T2_DEST)/humour/TOWTF/TOW_Fountainhead_1.txt: lib/screenplay-xml/txt/TOW_Fountainhead_1.txt
	cp -f $< $@

$(T2_DEST)/humour/TOWTF/TOW_Fountainhead_2.txt: lib/screenplay-xml/txt/TOW_Fountainhead_2.txt
	cp -f $< $@

$(T2_DEST)/humour/humanity/Humanity-Movie.txt: lib/screenplay-xml/txt/Humanity-Movie.txt
	cp -f $< $@

$(T2_DEST)/humour/Star-Trek/We-the-Living-Dead/star-trek--we-the-living-dead.txt: lib/screenplay-xml/txt/star-trek--we-the-living-dead.txt
	cp -f $< $@

%.show:
	@echo "$* = $($*)"

tidy: all
	perl bin/run-tidy.pl

.PHONY: install_docbook_pdfs install_docbook_xmls install_docbook_rtfs install_docbook_individual_xhtmls install_docbook_css_dirs

install_docbook_pdfs: make-dirs $(DOCBOOK_INSTALLED_PDFS)

install_docbook_xmls: make-dirs $(DOCBOOK_INSTALLED_XMLS)

install_docbook_rtfs: make-dirs  $(DOCBOOK_INSTALLED_RTFS)

install_docbook_individual_xhtmls: make-dirs $(DOCBOOK_INSTALLED_INDIVIDUAL_XHTMLS) $(DOCBOOK_INSTALLED_INDIVIDUAL_XHTMLS_CSS)

install_docbook_css_dirs: make-dirs $(DOCBOOK_INSTALLED_CSS_DIRS)

# This copies all the .pdf's at once - not ideal, but still
# working.
$(DOCBOOK_INSTALLED_PDFS) : $(DOCBOOK_PDFS)
	cp -f $(DOCBOOK_PDF_DIR)/$(notdir $@) $@

$(DOCBOOK_INSTALLED_XMLS) : $(DOCBOOK_XMLS)
	cp -f $(DOCBOOK_XML_DIR)/$(notdir $@) $@

$(DOCBOOK_INSTALLED_RTFS) : $(DOCBOOK_RTFS)
	cp -f $(DOCBOOK_RTF_DIR)/$(notdir $@) $@

$(DOCBOOK_INSTALLED_INDIVIDUAL_XHTMLS) : $(DOCBOOK_INDIVIDUAL_XHTMLS) $(DOCBOOK_INSTALLED_INDIVIDUAL_XHTMLS_CSS)
	rsync -r -v $(DOCBOOK_INDIVIDUAL_XHTML_DIR)/$(notdir $@) $(dir $@)

$(DOCBOOK_INSTALLED_CSS_DIRS) : lib/sgml/docbook-css/docbook-css-0.4/
	rsync -r -v $< $@

FORTUNES_XHTMLS_DIR = lib/fortunes/xhtmls

FORTUNES_XMLS_BASE = $(addsuffix .xml,$(FORTUNES_FILES_BASE))
FORTUNES_XMLS_SRC = $(patsubst %,$(T2_FORTUNES_DIR)/%,$(FORTUNES_XMLS_BASE))
FORTUNES_XHTMLS = $(patsubst $(T2_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_TEXTS = $(patsubst %.xml,%,$(FORTUNES_XMLS_SRC))
FORTUNES_ATOM_FEED = $(T2_FORTUNES_DIR)/fortunes-shlomif-all.atom

fortunes-compile-xmls: $(FORTUNES_XHTMLS) $(FORTUNES_TEXTS) $(FORTUNES_ATOM_FEED) 

# The touch is to make sure we compile the .html.wml again.

$(FORTUNES_XHTMLS): $(FORTUNES_XHTMLS_DIR)/%.xhtml : $(T2_FORTUNES_DIR)/%.xml
	bash $(T2_FORTUNES_DIR)/run-validator.bash $< && \
	perl $(T2_FORTUNES_DIR)/convert-to-xhtml.pl $< $@ && \
	touch $(patsubst %.xml,%.html.wml,$<)

$(FORTUNES_TEXTS): $(T2_FORTUNES_DIR)/%: $(T2_FORTUNES_DIR)/%.xml
	bash $(T2_FORTUNES_DIR)/run-validator.bash $< && \
	perl $(T2_FORTUNES_DIR)/convert-to-plaintext.pl $< $@

$(FORTUNES_ATOM_FEED): $(T2_FORTUNES_DIR)/generate-web-feeds.pl $(FORTUNES_XMLS_SRC)
	perl $< $@ $(T2_FORTUNES_DIR)

$(DOCBOOK_INSTALLED_INDIVIDUAL_XHTMLS_CSS):: %: $(DOCMAKE_STYLE_CSS)
	cp -f $< $@
