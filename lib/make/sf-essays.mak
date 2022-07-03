PUT_CARDS_2013_XHTML := lib/pages/t2/philosophy/putting-all-cards-on-the-table.xhtml
PUT_CARDS_2013_DEST := $(PRE_DEST)/philosophy/philosophy/put-cards-2013.xhtml
SUB_REPOS_BASE_DIR := $(LATEMP_ROOT_SOURCE_DIR)/lib/repos
TECH_BLOG_DIR := $(SUB_REPOS_BASE_DIR)/shlomif-tech-diary
TECH_TIPS_SCRIPT := $(TECH_BLOG_DIR)/extract-tech-tips.pl
TECH_TIPS_INPUTS := $(addprefix $(TECH_BLOG_DIR)/,old-tech-diary.xhtml tech-diary.xhtml)
TECH_TIPS_OUT := $(SUB_REPOS_BASE_DIR)/shlomif-tech-diary--tech-tips.xhtml

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

$(TECH_TIPS_OUT): $(TECH_TIPS_SCRIPT) $(TECH_TIPS_INPUTS)
	$(PERL) $(TECH_TIPS_SCRIPT) $(addprefix --file=,$(TECH_TIPS_INPUTS)) --output $@ --nowrap

$(PRE_DEST)/open-source/resources/tech-tips/index.xhtml: $(TECH_TIPS_OUT)
all_deps: $(TECH_TIPS_OUT)

$(PRE_DEST)/philosophy/computers/web/validate-your-html/index.xhtml: $(SUB_REPOS_BASE_DIR)/validate-your-html/README.md
$(PRE_DEST)/philosophy/computers/how-to-share-code-for-getting-help/index.xhtml: $(SUB_REPOS_BASE_DIR)/how-to-share-code-online/README.md

SAMSMITHXML := $(DOCBOOK5_SOURCES_DIR)/samsmith.xml
SAMSMITHXML_SRC := $(SUB_REPOS_BASE_DIR)/shlomif-tech-diary/multiverse-cosmology-v0.4.x.docbook5.xml
REALWORLDSENSE_SRC := $(SUB_REPOS_BASE_DIR)/shlomif-tech-diary/why-the-so-called-real-world-i-am-trapped-in-makes-little-sense--2020-05-19.docbook5.xml

$(SAMSMITHXML): $(SAMSMITHXML_SRC)
	$(PYTHON) bin/extract-docbook5-node.py $< '//*[@xml:id="history-lesson-about-the-muppeteers"]' > $@

COSMOLOGY_XML := $(DOCBOOK5_SOURCES_DIR)/multiverse-cosmology-v0.4.x.xml
REALWORLDSENSE_XML := $(DOCBOOK5_SOURCES_DIR)/why-the-so-called-real-world-makes-little-sense.xml

$(COSMOLOGY_XML): $(SAMSMITHXML_SRC)
	$(call COPY)

$(REALWORLDSENSE_XML): $(REALWORLDSENSE_SRC)
	$(call COPY)

docbook_targets: docbook_hhfg_images
docbook_targets: screenplay_targets
