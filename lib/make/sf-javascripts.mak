MATHJAX_SOURCE_README := lib/js/MathJax/README.md
MATHJAX_DEST_DIR := $(POST_DEST)/js/MathJax
MATHJAX_DEST_README := $(MATHJAX_DEST_DIR)/README.md

mathjax_dest: make-dirs $(MATHJAX_DEST_README)

$(MATHJAX_DEST_README): $(MATHJAX_SOURCE_README)
	@mkdir -p $(MATHJAX_DEST_DIR)/
	cp -PR lib/js/MathJax/{LICENSE,README.md,es5/} $(MATHJAX_DEST_DIR)/

SCRIPTS_WITH_OFFENDING_EXTENSIONS := MathVentures/gen-bugs-in-square-svg.pl open-source/bits-and-bobs/nowplay-xchat.pl open-source/bits-and-bobs/pmwiki-revert.pl open-source/bits-and-bobs/convert-kabc-dist-lists.pl
SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS := $(patsubst %.pl,$(POST_DEST)/%-pl.txt,$(SCRIPTS_WITH_OFFENDING_EXTENSIONS))

plaintext_scripts_with_offending_extensions: $(SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS)

NAV_DATA_AS_JSON := $(POST_DEST)/_data/nav.json

generate_nav_data_as_json: $(NAV_DATA_AS_JSON)

$(NAV_DATA_AS_JSON): $(NAV_DATA_DEP) $(NAV_DATA_AS_JSON_BIN) lib/Shlomif/Homepage/NavData/JSON.pm $(ALL_SUBSECTS_DEPS)
	./$(NAV_DATA_AS_JSON_BIN) -o $@

OUT_PREF = lib/out-babel/js
TYPESCRIPT_basenames = decss_for_typescript.js resize-iframe.js selfl.js sub_menu.js to-jqtree-2.js to-jqtree.js toggle_sect.js toggler.js
DEST_JS_DIR = $(POST_DEST)/js
dest_jsify = $(addprefix $(DEST_JS_DIR)/,$(1))

TYPESCRIPT_DEST_FILES = $(patsubst %.js,$(OUT_PREF)/%.js,$(TYPESCRIPT_basenames))
TYPESCRIPT_DEST_FILES__NODE = $(patsubst %.js,lib/for-node/js/%.js,$(TYPESCRIPT_basenames))
TYPESCRIPT_COMMON_DEFS_FILES = src/ts/jq_qs.d.ts
TYPESCRIPT_COMMON_DEPS =

DEST_BABEL_JSES = $(call dest_jsify,$(JSES_js_basenames) $(TYPESCRIPT_basenames))
OUT_BABEL_JSES = $(patsubst $(DEST_JS_DIR)/%,$(OUT_PREF)/%,$(DEST_BABEL_JSES))

$(DEST_BABEL_JSES): $(DEST_JS_DIR)/%.js: $(OUT_PREF)/%.js
	$(MULTI_YUI) -o $@ $<

all: $(call dest_jsify, resize-iframe.js)

# run_tsc = tsc --target es6 --moduleResolution node --module $1 --outDir $$(dirname $@) $<
run_tsc = tsc --project lib/typescript/$1/tsconfig.json

$(TYPESCRIPT_DEST_FILES): $(OUT_PREF)/%.js: src/ts/%.ts $(TYPESCRIPT_COMMON_DEPS)
	$(call run_tsc,www)

$(TYPESCRIPT_DEST_FILES__NODE): lib/for-node/js/%.js: src/ts/%.ts $(TYPESCRIPT_COMMON_DEPS)
	$(call run_tsc,cmdline)

tsc_www:
	$(call run_tsc,www)

tsc_cmdline:
	$(call run_tsc,cmdline)

serial_run: tsc_www tsc_cmdline

$(PRE_DEST)/site-map/index.xhtml: $(ALL_SUBSECTS_DEPS)

MAIN_TOTAL_MIN_JS_DEST := $(POST_DEST)/js/main_all.js
TREE_JS_DEST := $(POST_DEST)/js/tree.jquery.js
EXPANDER_MIN_JS_DEST := $(POST_DEST)/js/jquery.expander.min.js
EXPANDER_JS_DEST := $(POST_DEST)/js/jquery.expander.js
EXPANDER_JS_SRC := lib/js/jquery-expander/jquery.expander.js
MULTI_YUI := $(LATEMP_ROOT_SOURCE_DIR)/bin/Run-YUI-Compressor

$(EXPANDER_MIN_JS_DEST): $(EXPANDER_JS_SRC)
	$(MULTI_YUI) -o $@ $<

# Must not be sorted!
MAIN_TOTAL_MIN_JS__SOURCES := \
	bower_components/jquery/dist/jquery.min.js \
	$(DEST_JS_DIR)/toggler.js \
	$(DEST_JS_DIR)/toggle_sect.js \
	bower_components/jqTree/tree.jquery.js \
	$(DEST_JS_DIR)/to-jqtree.js \
	$(DEST_JS_DIR)/to-jqtree-2.js \
	$(DEST_JS_DIR)/selfl.js \
	$(DEST_JS_DIR)/sub_menu.js \

$(MAIN_TOTAL_MIN_JS_DEST): $(MULTI_YUI) $(MAIN_TOTAL_MIN_JS__SOURCES)
	$(MULTI_YUI) -o $@ $(MAIN_TOTAL_MIN_JS__SOURCES)

$(TREE_JS_DEST): bower_components/jqTree/tree.jquery.js
	$(call COPY)

