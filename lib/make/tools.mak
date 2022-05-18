EXTRACT_html_script := $(LATEMP_ROOT_SOURCE_DIR)/bin/extract-xhtml.pl
GEN_SECT_NAV_MENUS := $(LATEMP_ROOT_SOURCE_DIR)/bin/gen-sect-nav-menus.pl
GNUMAKE := gmake
IMAGE_CONVERT := gm convert
INKSCAPE_WRAPPER := $(LATEMP_ROOT_SOURCE_DIR)/bin/inkscape-wrapper
NAV_DATA_AS_JSON_BIN := $(LATEMP_ROOT_SOURCE_DIR)/bin/nav-data-as-json
OPTIPNG := optipng -quiet
PROCESS_ALL_INCLUDES__NON_INPLACE := $(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/post-incs-v2.pl
REBOOKMAKER := rebookmaker
VERED := $(LATEMP_ROOT_SOURCE_DIR)/bin/translate-Vered-XML
PYTHON = python3
extract_gzipped_xhtml = gunzip < $< | $(PERL) $(EXTRACT_html_script) -o $@ -
find_htmls = find $(1) -name '*.html' -o -name '*.xhtml'
simple_gm = $(IMAGE_CONVERT) $< $@

define ASCIIDOCTOR_TO_DOCBOOK5
	asciidoctor --backend=docbook5 -o >(xsltproc bin/clean-up-asciidoctor-docbook5.xslt - > $@) $<
endef

define ASCIIDOCTOR_TO_RAW_XHTML5
	asciidoctor --backend=xhtml5 -e -o $@ $<
endef

define ASCIIDOCTOR_TO_XHTML5
	asciidoctor --backend=xhtml5 -o $@ $<
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/clean-up-asciidoctor-xhtml5.pl $@
endef

define EXPORT_INKSCAPE_PNG
	$(INKSCAPE_WRAPPER) --export-width=200 --export-type=png --export-filename="$@" $<
	$(OPTIPNG) $@
endef

STRIP_HTML_BIN := $(LATEMP_ROOT_SOURCE_DIR)/bin/processors/strip-html-overhead.pl
strip_html = $(PERL) $(STRIP_HTML_BIN) < $< > $@
