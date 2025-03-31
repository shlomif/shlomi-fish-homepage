GEN_STYLE_CSS_FILES := \
cats-photos.css faq-indiv.css fort_total.css fortunes.css fortunes_show.css jqui-override.css print.css screenplay.css screenplay-xml-pdfs.css slash-humour.css style-404.css style.css

SRC_CSS_TARGETS := $(addprefix $(POST_DEST)/,$(GEN_STYLE_CSS_FILES))

css_targets: $(SRC_CSS_TARGETS)

SASS_STYLE := compressed
# SASS_STYLE := expanded
SASS_DEBUG_FLAGS :=
SASS_CMD = pysassc $(SASS_DEBUG_FLAGS) --style $(SASS_STYLE)

FORT_SASS_DEPS := lib/sass/fortunes.scss
COMMON_SASS_DEPS := lib/sass/bk2hp.scss lib/sass/common-body.scss lib/sass/common-style--bottom-imports.scss lib/sass/common-style-main.scss lib/sass/common-style.scss lib/sass/defs.scss lib/sass/faq-common.scss lib/sass/faq-indiv.scss lib/sass/footer.scss lib/sass/lang_switch.scss lib/sass/mixins.scss

$(SRC_CSS_TARGETS): $(POST_DEST)/%.css: lib/sass/%.scss $(COMMON_SASS_DEPS)
	$(SASS_CMD) $< $@

$(POST_DEST)/style.css $(POST_DEST)/print.css: $(COMMON_SASS_DEPS) lib/sass/lang_switch.scss $(FORT_SASS_DEPS) lib/sass/code_block.scss lib/sass/jqtree.scss lib/sass/treeview.scss lib/sass/common-with-print.scss lib/sass/self_link.scss

$(POST_DEST)/style.css: lib/sass/footer.scss

$(POST_DEST)/fortunes_show.css: $(COMMON_SASS_DEPS)

$(POST_DEST)/fort_total.css: $(FORT_SASS_DEPS) lib/sass/fortunes.scss lib/sass/fortunes_show.scss $(COMMON_SASS_DEPS) lib/sass/screenplay.scss
