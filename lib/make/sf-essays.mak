PUT_CARDS_2013_XHTML := lib/pages/t2/philosophy/putting-all-cards-on-the-table.xhtml
PUT_CARDS_2013_DEST := $(PRE_DEST)/philosophy/philosophy/put-cards-2013.xhtml

PUT_CARDS_2013_XHTML_STRIPPED := $(PUT_CARDS_2013_XHTML).processed-stripped

$(PUT_CARDS_2013_XHTML_STRIPPED): $(PUT_CARDS_2013_XHTML) $(STRIP_HTML_BIN)
	$(call strip_html)

PUT_CARDS_2013_DEST_INDIV := $(PRE_DEST)/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/tie_your_camel.xhtml
PUT_CARDS_2013_INDIV_SCRIPT := $(LATEMP_ROOT_SOURCE_DIR)/bin/split-put-cards-into-divs.pl

all_deps: $(PUT_CARDS_2013_DEST_INDIV)

$(PUT_CARDS_2013_DEST_INDIV): $(PUT_CARDS_2013_XHTML) $(PUT_CARDS_2013_INDIV_SCRIPT)
	$(PERL) $(PUT_CARDS_2013_INDIV_SCRIPT)

HOW_TO_GET_HELP_2013_XHTML := lib/pages/t2/philosophy/how-to-get-help-online.xhtml
HOW_TO_GET_HELP_2013_XHTML_STRIPPED := $(HOW_TO_GET_HELP_2013_XHTML).processed-stripped

$(HOW_TO_GET_HELP_2013_XHTML_STRIPPED): $(HOW_TO_GET_HELP_2013_XHTML) $(STRIP_HTML_BIN)
	$(call strip_html)

$(PRE_DEST)/philosophy/computers/how-to-get-help-online/2013.html: $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)

all_deps: $(HOW_TO_GET_HELP_2013_XHTML_STRIPPED)

MOJOLICIOUS_LECTURE_SLIDE1 := $(PRE_DEST)/lecture/Perl/Lightning/Mojolicious/mojolicious-slides.html

HACKING_DOC := $(PRE_DEST)/open-source/resources/how-to-contribute-to-my-projects/HACKING.html

mojo_pres: $(MOJOLICIOUS_LECTURE_SLIDE1) $(HACKING_DOC)

CHRISTINA_GRIMMIE_LETTER_SOURCE = lib/asciidocs/letter-to-christina-grimmie.asciidoc
CHRISTINA_GRIMMIE_LETTER_HTML = lib/asciidocs/letter-to-christina-grimmie.asciidoc.xhtml

$(CHRISTINA_GRIMMIE_LETTER_HTML): $(CHRISTINA_GRIMMIE_LETTER_SOURCE)
	$(call ASCIIDOCTOR_TO_RAW_XHTML5)

$(MOJOLICIOUS_LECTURE_SLIDE1): $(SRC_SRC_DIR)/lecture/Perl/Lightning/Mojolicious/mojolicious.asciidoc.txt
	$(call ASCIIDOCTOR_TO_XHTML5)

$(HACKING_DOC): $(SRC_SRC_DIR)/open-source/resources/how-to-contribute-to-my-projects/HACKING.txt
	$(call ASCIIDOCTOR_TO_XHTML5)

all_deps: $(CHRISTINA_GRIMMIE_LETTER_HTML)
