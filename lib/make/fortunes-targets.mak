FORTUNES_XHTMLS_DIR := lib/fortunes/xhtmls
FORTUNES_ALL_IN_ONE__BASE := all-in-one.html
FORTUNES_ALL_IN_ONE__TEMP__BASE := all-in-one.uncompressed.html
SRC_FORTUNES_ALL__HTML := $(PRE_DEST_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__BASE)
SRC_FORTUNES_ALL__HTML__POST := $(POST_DEST_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__TEMP__BASE)
SRC_FORTUNES_ALL_TT2 := $(SRC_FORTUNES_DIR)/$(FORTUNES_ALL_IN_ONE__TEMP__BASE).tt2

FORTUNES_LIST_PM := lib/Shlomif/Homepage/FortuneCollections.pm
FORTUNES_LIST__DEPS := $(FORTUNES_LIST_PM) lib/Shlomif/fortunes-meta-data.yml

FORTUNES_XMLS_BASE := $(addsuffix .xml,$(FORTUNES_FILES_BASE))
FORTUNES_XMLS_SRC := $(addprefix $(SRC_FORTUNES_DIR)/,$(FORTUNES_XMLS_BASE))
FORTUNES_XHTMLS := $(patsubst $(SRC_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_XHTMLS_TOCS := $(patsubst $(SRC_FORTUNES_DIR)/%.xml,$(FORTUNES_XHTMLS_DIR)/%.toc-xhtml,$(FORTUNES_XMLS_SRC))
FORTUNES_SOURCE_TT2S := $(patsubst %,$(SRC_FORTUNES_DIR)/%.html.tt2,$(FORTUNES_FILES_BASE))
FORTUNES_DEST_HTMLS := $(patsubst $(SRC_FORTUNES_DIR)/%.html.tt2,$(PRE_DEST_FORTUNES_DIR)/%.html,$(FORTUNES_SOURCE_TT2S))
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

FORTUNES_BUILT_TARGETS := $(FORTUNES_SOURCE_TT2S) $(FORTUNES_XHTMLS) $(FORTUNES_TEXTS) $(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED) $(FORTUNES_SQLITE_DB) $(FORTUNES__SHOW_PY__PRE_DEST) $(FORTUNES_TEXTS__PRE_DEST) $(FORTUNES_DATS__PRE_DEST)

fortunes-compile-xmls: $(FORTUNES_BUILT_TARGETS)

FORTUNES_CONVERT_TO_XHTML_SCRIPT := $(SRC_FORTUNES_DIR)/convert-to-xhtml.pl
FORTUNES_PREPARE_FOR_INPUT_SCRIPT := $(SRC_FORTUNES_DIR)/prepare-xhtml-for-input.pl

$(FORTUNES__SHOW_PY__PRE_DEST): %: $(SRC_SRC_FORTUNE_SHOW_PY)
	$(call chmod_copy)

$(FORTUNES_SOURCE_TT2S): $(FORTUNES_LIST__DEPS)
	$(PERL) -I $(LATEMP_ROOT_SOURCE_DIR)/lib -MShlomif::Homepage::FortuneCollections -e 'Shlomif::Homepage::FortuneCollections->new->print_all_fortunes_html_tt2s;'

$(FORTUNES_XHTMLS__FOR_INPUT_PORTIONS): %.xhtml-for-input: %.xhtml $(FORTUNES_PREPARE_FOR_INPUT_SCRIPT)
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

$(FORTUNES_TEXTS): $(SRC_FORTUNES_DIR)/%: $(SRC_FORTUNES_DIR)/%.xml
	$(PERL) $(SRC_FORTUNES_DIR)/validate-and-convert-to-plaintext.pl $< $@

$(FORTUNES_ATOM_FEED) $(FORTUNES_RSS_FEED): $(SRC_FORTUNES_DIR)/generate-web-feeds.pl $(FORTUNES_XMLS_SRC)
	$(PERL) $< --atom $(FORTUNES_ATOM_FEED) --rss $(FORTUNES_RSS_FEED) --dir $(SRC_FORTUNES_DIR)

$(FORTUNES_SQLITE_DB): $(SRC_FORTUNES_DIR)/populate-sqlite-database.pl $(FORTUNES_XHTMLS) $(FORTUNES_LIST__DEPS) $(FORTUNES_TEXTS__PRE_DEST)
	$(PERL) -I $(LATEMP_ROOT_SOURCE_DIR)/lib $<

$(FORTUNES_TARGET): $(SRC_FORTUNES_DIR)/index.xhtml.tt2 $(DOCS_COMMON_DEPS) $(HUMOUR_DEPS) $(SRC_FORTUNES_DIR)/Makefile $(SRC_FORTUNES_DIR)/ver.txt

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

$(FORTS_EPUB_COVER_JPG): $(FORTS_EPUB_COVER_PNG)
	$(call simple_gm)

$(FORTS_EPUB_COVER_PNG): $(FORTS_EPUB_COVER_SVG)
	$(INKSCAPE_WRAPPER) --export-width=600 --export-type=png --export-filename="$@" $< && \
	$(OPTIPNG) $@

PRE_DEST_FORTUNES_many_files := $(PRE_DEST_FORTUNES)
POST_DEST_FORTUNES_many_files := $(POST_DEST_FORTUNES_SQLITE_DB)

$(SRC_FORTUNES_ALL__HTML__POST): $(SRC_CLEAN_STAMP)
all_deps: $(SRC_FORTUNES_ALL_TT2)
copy_fortunes: $(PRE_DEST_FORTUNES_many_files) $(POST_DEST_FORTUNES_many_files)
