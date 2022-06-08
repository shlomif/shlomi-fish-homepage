$(ALL_HTACCESSES): $(PRE_DEST)/%/.htaccess: $(SRC_SRC_DIR)/%/my_htaccess.conf
$(BK2HP_SVG_SRC): lib/repos/Shlomi-Fish-Back-to-my-Homepage-Logo/back-to-my-homepage-logo/back-to-my-homepage--scripted-final--with-gradient-applied--cropped.svg
$(CATB_COPY): $(SRC_SRC_DIR)/homesteading/$(CATB_HEB_BN)
$(CATB_COPY_POST): $(CATB_COPY)
$(DOCBOOK5_ALL_IN_ONE_XHTMLS_CSS): %/style.css: $(DOCMAKE_STYLE_CSS) %/all-in-one.html
$(DOCBOOK5_HHFG_IMAGES_POST_DEST): $(DOCBOOK5_HHFG_POST_DEST_DIR)/%: $(DOCBOOK5_BASE_DIR)/style/human-hacking-field-guide/% $(DOCBOOK5_HHFG_DEST_DIR)/index.xhtml
$(DOCBOOK5_SOURCES_DIR)/hebrew-html-tutorial.xml: $(HTML_TUT_HEB_DB)
$(DOCBOOK5_SOURCES_DIR)/putting-cards-on-the-table-2019-2020.xml: lib/repos/putting-cards-2019-2020/shlomif-putting-cards-on-the-table-2019-2020.docbook5.xml
$(EXPANDER_JS_DEST): $(EXPANDER_JS_SRC)
$(HHFG_HEB_V2_XSLT_POST_DEST): $(FICTION_XML_DB5_XSLT_DIR)/human-hacking-field-guide-hebrew-v2.xslt
$(HHFG_V2_IMAGES_POST_DEST): $(HHFG_V2_IMAGES_POST_DEST_DIR)/%: $(DOCBOOK5_BASE_DIR)/style/human-hacking-field-guide/% $(HHFG_V2_IMAGES_DEST_DIR)/index.xhtml
$(HHFG_V2_IMAGES_POST_DEST_FROM_VCS): $(HHFG_V2_IMAGES_POST_DEST_DIR_FROM_VCS)/%: $(DOCBOOK5_BASE_DIR)/style/human-hacking-field-guide/% $(HHFG_V2_IMAGES_DEST_DIR)/index.xhtml
$(HHGG_CONVERT_SCRIPT_DEST): $(HHGG_CONVERT_SCRIPT_SRC)
$(POST_DEST_FIERY_Q_PNG): lib/screenplay-xml/from-vcs/Star-Trek--We-the-Living-Dead/star-trek--we-the-living-dead/graphics/Fiery-Q--no-background--one-layer--reduced.png
$(POST_DEST_FORTUNES_many_files): $(POST_DEST)/%: $(SRC_SRC_DIR)/%
$(POST_DEST_FORTUNE_SHOW_SCRIPT_TXT): $(SRC_SRC_FORTUNE_SHOW_SCRIPT)
$(POST_DEST_INTERVIEWS)/ae-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/ae-interview.txt
$(POST_DEST_INTERVIEWS)/sussman-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/sussman-interview.txt
$(POST_DEST_POPE)/The-Pope-Died-on-Sunday-english.xml: $(DOCBOOK5_XML_DIR)/The-Pope-Died-on-Sunday-english.xml
$(POST_DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.xml: $(DOCBOOK5_XML_DIR)/The-Pope-Died-on-Sunday-hebrew.xml
$(POST_DEST_SPLAY_HHGG_STTNG): $(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng-hand-tweaked.txt
$(POST_DEST__C_BAD_ELEMS): $(C_BAD_ELEMS_SRC)
$(PRE_DEST_FORTUNES_many_files) $(FORTUNES_TEXTS__PRE_DEST) $(FORTUNES_DATS__PRE_DEST): $(PRE_DEST)/%: $(SRC_SRC_DIR)/%
$(PUT_CARDS_2013_DEST): $(PUT_CARDS_2013_XHTML)
$(SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS): $(POST_DEST)/%-pl.txt: $(SRC_SRC_DIR)/%.pl
$(SITE_SOURCE_INSTALL_TARGET): INSTALL.md
$(SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES__test_run): $(SPORK_test_run_dir)/%: src/lecture/images/%
$(SPORK_LECTS_SOURCE_DOWNLOADED_IMAGES__too_many): $(SPORK_too_many_ways_dir)/%: src/images/presentations/%
$(SRC_FORTUNES_ALL__HTML): %/$(FORTUNES_ALL_IN_ONE__BASE): %/$(FORTUNES_ALL_IN_ONE__TEMP__BASE) fastrender-tt2
common/js/jq.js: node_modules/jquery/dist/jquery.min.js
