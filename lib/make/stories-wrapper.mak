lib/htmls/The-Enemy-English-rev5.html-part: $(SRC_SRC_DIR)/humour/TheEnemy/The-Enemy-English-rev5.xhtml.gz $(EXTRACT_html_script)
	$(call extract_gzipped_xhtml)

lib/htmls/The-Enemy-English-rev6.html-part: $(SRC_SRC_DIR)/humour/TheEnemy/The-Enemy-English-rev6.xhtml.gz $(EXTRACT_html_script)
	$(call extract_gzipped_xhtml)

lib/htmls/The-Enemy-rev5.html-part: $(SRC_SRC_DIR)/humour/TheEnemy/The-Enemy-Hebrew-rev5.xhtml.gz $(EXTRACT_html_script)
	$(call extract_gzipped_xhtml)

all_deps: lib/htmls/The-Enemy-English-rev5.html-part
all_deps: lib/htmls/The-Enemy-English-rev6.html-part
all_deps: lib/htmls/The-Enemy-rev5.html-part

SCREENPLAY_XML_BASE_DIR := lib/screenplay-xml
SCREENPLAY_XML_EPUB_DIR := $(SCREENPLAY_XML_BASE_DIR)/epub
SCREENPLAY_XML_XML_DIR := $(SCREENPLAY_XML_BASE_DIR)/xml
SCREENPLAY_XML_TXT_DIR := $(SCREENPLAY_XML_BASE_DIR)/txt
SCREENPLAY_XML_TT2_TXT_DIR := $(SCREENPLAY_XML_BASE_DIR)/tt2-txt
SCREENPLAY_XML_HTML_DIR := $(SCREENPLAY_XML_BASE_DIR)/html
SCREENPLAY_XML_RENDERED_HTML_DIR := $(SCREENPLAY_XML_BASE_DIR)/rendered-html

FICTION_XML_BASE_DIR := lib/fiction-xml
FICTION_XML_XML_DIR := $(FICTION_XML_BASE_DIR)/xml
FICTION_XML_TXT_DIR := $(FICTION_XML_BASE_DIR)/txt
FICTION_XML_DB5_XSLT_DIR := $(FICTION_XML_BASE_DIR)/docbook5-post-proc
FICTION_XML_TEMP_DB5_DIR := $(FICTION_XML_BASE_DIR)/intermediate-docbook5-results

include lib/make/generated/shlomif-screenplays.mak

SCREENPLAY_DOCS_ADDITIONS := \
	Emma-Watson-applying-for-a-software-dev-job \
	Emma-Watson-visit-to-Israel-and-Gaza \
	Mighty-Boosh--Ape-of-Death--Scenes \
	ae-interview \
	hitchhikers-guide-to-star-trek-tng-hand-tweaked \
	humanity-excerpt-for-X-G-Screenplay-demo \
	sussman-interview

SCREENPLAY_DOCS := $(SCREENPLAY_DOCS_ADDITIONS) $(SCREENPLAY_DOCS_FROM_GEN)

FICTION_DOCS_ADDITIONS := \
	fiction-text-example-for-X-G-Fiction-demo \
	The-Enemy-Hebrew-rev6 \
	The-Enemy-Hebrew-v7

FICTION_DOCS := $(FICTION_DOCS_ADDITIONS) $(FICTION_DOCS_FROM_GEN)
DOCBOOK5_DOCS += $(FICTION_DOCS)

SCREENPLAY_XMLS := $(patsubst %,$(SCREENPLAY_XML_XML_DIR)/%.xml,$(SCREENPLAY_DOCS))
FICTION_XMLS := $(patsubst %,$(FICTION_XML_XML_DIR)/%.xml,$(FICTION_DOCS_ADDITIONS))

non_latemp_targets: splay

include lib/make/generated/sf-homepage-quadpres-generated.mak

$(PRES_WEBSITE_META_LECTURE_STAMP): $(PRES_WEBSITE_META_LECTURE_DEST)/examples/common_look/dest/my-document.pdf
$(PRES_WEBSITE_META_LECTURE_DEST)/examples/common_look/dest/my-document.pdf: $(PRES_WEBSITE_META_LECTURE_DEPS) $(PRES_WEBSITE_META_LECTURE_BASE)/src/index.html.wml $(PRES_WEBSITE_META_LECTURE_SRC_FILES)
	$(call PRES_WEB_PUBLISHING_WITH_LAMP_render)

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

include lib/make/hhfg.mak

FICTION_TEXT_SOURCES_ON_POST_DEST := $(POST_DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.txt $(HHFG_HEB_V2_POST_DEST) $(HHFG_HEB_V2_XSLT_POST_DEST) $(POST_DEST_POPE)/The-Pope-Died-on-Sunday-english.txt

translate_fiction_text_to_xml = $(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/fiction-text-to-xml.pl -o $@ $<

$(FICTION_XMLS): $(FICTION_XML_XML_DIR)/%.xml: $(FICTION_XML_TXT_DIR)/%.txt
	$(call translate_fiction_text_to_xml)

HHGG_CONVERT_SCRIPT_FN := convert-hitchhiker-guide-to-st-tng-to-screenplay-xml.pl
HHGG_CONVERT_SCRIPT_SRC := $(LATEMP_ROOT_SOURCE_DIR)/bin/processors/$(HHGG_CONVERT_SCRIPT_FN)
HHGG_CONVERT_SCRIPT_DEST := $(PRE_DEST_HUMOUR)/by-others/$(HHGG_CONVERT_SCRIPT_FN).txt

hhgg_convert: $(HHGG_CONVERT_SCRIPT_DEST)

$(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng.txt : $(HHGG_CONVERT_SCRIPT_SRC) $(SRC_SRC_DIR)/humour/by-others/hitchhiker-guide-to-star-trek-tng.txt
	$(PERL) $<

MY_TT_PROCESSOR = $(PERL) bin/my-tt-processor.pl -o $@ $<

$(ALL-IN-AN-ATYPICAL-DAY-WORK__SCREENPLAY_XML_SOURCE) : $(SCREENPLAY_XML_TT2_TXT_DIR)/All-in-an-Atypical-Day-Work.screenplay-text.txt.tt2
	$(call MY_TT_PROCESSOR)

$(HE-DAMSEL-IN-DISTRESS-AND-A-DISTRESSING-DAMSEL__SCREENPLAY_XML_SOURCE) : $(SCREENPLAY_XML_TT2_TXT_DIR)/He-Damsel-in-Distress-and-a-Distressing-Damsel.screenplay-text.txt.tt2
	$(call MY_TT_PROCESSOR)

screenplay_epub_dests: $(SCREENPLAY_XML__EPUBS_DESTS)

$(PRE_DEST)/open-source/projects/XML-Grammar/Fiction/index.xhtml: \
	$(FICTION_XML_TXT_DIR)/fiction-text-example-for-X-G-Fiction-demo.txt \
	$(SCREENPLAY_XML_RENDERED_HTML_DIR)/humanity-excerpt-for-X-G-Screenplay-demo.html \
	$(SCREENPLAY_XML_TXT_DIR)/humanity-excerpt-for-X-G-Screenplay-demo.txt \
