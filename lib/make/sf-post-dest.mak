SRC_CACHE_PREFIX := lib/cache/combined/t2

$(SRC_DOCS_DEST): $(PRE_DEST)/%: \
	$(SRC_CACHE_PREFIX)/%/breadcrumbs-trail \
	$(SRC_CACHE_PREFIX)/%/html_head_nav_links \
	$(SRC_CACHE_PREFIX)/%/main_nav_menu_html \
	$(SRC_CACHE_PREFIX)/%/sect-navmenu \
	$(SRC_CACHE_PREFIX)/%/shlomif_nav_links_renderer-with_accesskey= \
	$(SRC_CACHE_PREFIX)/%/shlomif_nav_links_renderer-with_accesskey=1 \

all_deps: $(SRC_CLEAN_STAMP)

PROC_INCLUDES_COMMON2 = APPLY_TEXTS=1 xargs $(PROCESS_ALL_INCLUDES__NON_INPLACE) --mode=minify --minifier-conf=bin/html-min-cli-config-file.conf --texts-dir=lib/ads --source-dir=$(1) --dest-dir=$(2) --
PROC_INCLUDES_COMMON := $(call PROC_INCLUDES_COMMON2,$(PRE_DEST),$(POST_DEST))

APPLY_LYNX_BETA_COMPAT = 1
SKIP_EPUBS_NORMALIZE_DUE_TO_INVALID_EPUBS = 0
STRIP_src_dir_DEST := $(PERL) -lpe 's=\A(?:./)?$(PRE_DEST)/?=='

$(SRC_CLEAN_STAMP): $(BK2HP_NEW_PNG) $(DOCBOOK5_INSTALLED_EPUBS) $(FORTS_EPUB_DEST) $(FORTUNES_BUILT_TARGETS) $(MATHJAX_DEST_README) $(POST_DEST_XZ_MODS) $(POST_DEST_ZIP_MODS) $(PRES_TARGETS_ALL_FILES) $(SCREENPLAY_XML__EPUBS_DESTS) $(SCREENPLAY_XML__RAW_HTMLS__DESTS) $(SPORK_LECTURES_DEST_STARTS) $(SRC_DOCS_DEST)
	$(call find_htmls,$(PRE_DEST)) | grep -vF -e philosophy/by-others/sscce -e WebMetaLecture/slides/examples -e homesteading/catb-heb | $(STRIP_src_dir_DEST) | $(PROC_INCLUDES_COMMON)
	rsync --exclude '*.html' --exclude '*.xhtml' -a $(PRE_DEST)/ $(POST_DEST)/
	if test "$(SKIP_EPUBS_NORMALIZE_DUE_TO_INVALID_EPUBS)" != "1" ; then find $(POST_DEST) -name '*.epub' -o -name '*.zip' | xargs -n 3 -P 8 $(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/normalize-zips.pl ; fi
	$(PERL) $(LATEMP_ROOT_SOURCE_DIR)/bin/gen-index-xhtmls-redirects.pl
	WMLect_PATH="lecture/WebMetaLecture/slides/examples" ; rsync -a $(PRE_DEST)/$$WMLect_PATH/ $(POST_DEST)/$$WMLect_PATH
	if test "$(APPLY_LYNX_BETA_COMPAT)" = "1" ; then python3 bin/xhtml-tweak-for-lynx.py ; fi
	touch $@

test:
	if test "$(APPLY_LYNX_BETA_COMPAT)" = "1" ; then python3 bin/xhtml-tweak-for-lynx.py ; fi

FASTRENDER_DEPS := $(patsubst $(PRE_DEST)/%,$(SRC_SRC_DIR)/%.tt2,$(SRC_DOCS_DEST)) all_deps

fastrender: fastrender-tt2 $(SRC_FORTUNES_ALL__HTML)

fastrender-tt2: $(FASTRENDER_DEPS)
	@echo $(MAKE) fastrender-tt2
	perl bin/tt-render.pl

copy_images_target: $(SRC_IMAGES_DEST) $(SRC_COMMON_IMAGES_DEST)
