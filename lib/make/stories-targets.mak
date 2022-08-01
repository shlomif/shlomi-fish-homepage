docbook_targets: pope_fiction selina_mandrake hhfg_fiction

$(PRE_DEST)/lecture/Perl/Newbies/lecture5-heb-notes.html: $(SRC_SRC_DIR)/lecture/Perl/Newbies/lecture5-notes.txt

$(PRE_DEST)/philosophy/by-others/perlcast-transcript--tom-limoncelli-interview/index.xhtml: lib/htmls/from-mediawiki/processed/Perlcast_Transcript_-_Interview_with_Tom_Limoncelli.html

HTML_TUT_BASE := lib/presentations/docbook/html-tutorial/hebrew-html-tutorial

HTML_TUT_HEB_DIR := $(HTML_TUT_BASE)/hebrew-html-tutorial
HTML_TUT_HEB_DB := $(HTML_TUT_BASE)/hebrew-html-tutorial.xml
HTML_TUT_HEB_TT := $(HTML_TUT_BASE)/hebrew-html-tutorial.xml.tt
PRE_DEST_HTML_TUT_BASE := $(PRE_DEST)/lecture/HTML-Tutorial/v1/xhtml1/hebrew
PRE_DEST_HTML_TUT := $(PRE_DEST_HTML_TUT_BASE)/index.xhtml

selina_mandrake: $(SELINA_MANDRAKE_SCREENPLAY_SCREENPLAY_XML_SOURCE) $(SELINA_MANDRAKE_SCREENPLAY_TXT_FROM_VCS)

selina_mandrake__dest_images: $(ALL_SCREENPLAYS__SCREENPLAY_IMAGES__POST_DESTS)

selina_mandrake: selina_mandrake__dest_images

pope_fiction: $(POPE_ENG_FICTION_XML_SOURCE)

QUEEN_PADME_TALES__teaser_dir := $(POST_DEST_HUMOUR)/Queen-Padme-Tales/teaser
QUEEN_PADME_TALES__teaser_pivot := $(QUEEN_PADME_TALES__teaser_dir)/index.xhtml

screenplay_targets: $(ST_WTLD_TEXT_IN_TREE) $(SCREENPLAY_XMLS) $(SCREENPLAY_HTMLS) $(SCREENPLAY_RENDERED_HTMLS) $(SCREENPLAY_SOURCES_ON_POST_DEST) $(FICTION_TEXT_SOURCES_ON_POST_DEST) $(SELINA_MANDRAKE_SCREENPLAY_SCREENPLAY_XML_SOURCE) $(SUMMERSCHOOL_AT_THE_NSA_SCREENPLAY_SCREENPLAY_XML_SOURCE) screenplay_epub_dests

$(PRE_DEST_HTML_TUT): $(HTML_TUT_HEB_HTML)
	$(MKDIR) $(PRE_DEST_HTML_TUT_BASE)
	rsync -r $(HTML_TUT_HEB_DIR)/ $(PRE_DEST_HTML_TUT_BASE)

screenplay_targets: $(QUEEN_PADME_TALES__teaser_pivot)

sync_teaser_func = $(MKDIR) $(QUEEN_PADME_TALES__teaser_dir) && rsync -a lib/repos/Star-Wars-opening-crawl-from-1977-Remake/ $(QUEEN_PADME_TALES__teaser_dir)

$(QUEEN_PADME_TALES__teaser_pivot):
	$(call sync_teaser_func)

sync_teaser:
	$(call sync_teaser_func)

$(HTML_TUT_HEB_DB): $(HTML_TUT_HEB_TT)
	cd $(HTML_TUT_BASE) && $(GNUMAKE) docbook

FICTION_DB5S := $(patsubst %,$(DOCBOOK5_XML_DIR)/%.xml,$(FICTION_DOCS))

$(FICTION_DB5S): $(DOCBOOK5_XML_DIR)/%.xml: $(FICTION_XML_XML_DIR)/%.xml
	xslt="$(patsubst $(FICTION_XML_XML_DIR)/%.xml,$(FICTION_XML_DB5_XSLT_DIR)/%.xslt,$<)" ; \
	if test -e "$$xslt" ; then \
		temp_db5="$(patsubst $(FICTION_XML_XML_DIR)/%.xml,$(FICTION_XML_TEMP_DB5_DIR)/%.xml,$<)" ; \
		$(PERL) -MXML::Grammar::Fiction::App::ToDocBook -e 'run()' -- \
			-o "$$temp_db5" $< && \
		xsltproc --output "$@" "$$xslt" "$$temp_db5" ; \
	else \
		$(PERL) -MXML::Grammar::Fiction::App::ToDocBook -e 'run()' -- \
			-o $@ $< ; \
	fi
	$(PERL) -i -lpe 's/\s+$$//' $@

SCREENPLAY_XML__RAW_HTMLS__POST_DESTS := $(patsubst $(PRE_DEST)/%,$(POST_DEST)/%,$(SCREENPLAY_XML__RAW_HTMLS__DESTS))
SCREENPLAY_XML__PDFS__POST_DESTS := $(patsubst %.raw.html,%.pdf,$(SCREENPLAY_XML__RAW_HTMLS__POST_DESTS))

$(SCREENPLAY_XML__PDFS__POST_DESTS): %.pdf: %.raw.html
	weasyprint "$<" "$@"

screenplays_pdfs: $(SCREENPLAY_XML__PDFS__POST_DESTS)

docbook_extended: screenplays_pdfs
