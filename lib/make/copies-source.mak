$(ALL_HTACCESSES): $(T2_DEST)/%/.htaccess: $(T2_SRC_DIR)/%/my_htaccess.conf
$(BK2HP_SVG_SRC): lib/repos/Shlomi-Fish-Back-to-my-Homepage-Logo/back-to-my-homepage-logo/back-to-my-homepage--scripted-final--with-gradient-applied--cropped.svg
$(DEST_FIERY_Q_PNG): lib/screenplay-xml/from-vcs/Star-Trek--We-the-Living-Dead/star-trek--we-the-living-dead/graphics/Fiery-Q--no-background--one-layer--reduced.png
$(DEST_INTERVIEWS)/ae-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/ae-interview.txt
$(DEST_INTERVIEWS)/sussman-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/sussman-interview.txt
$(DEST_POPE)/The-Pope-Died-on-Sunday-english.txt: $(FICTION_XML_TXT_DIR)/The-Pope-Died-on-Sunday-english.txt
$(DEST_POPE)/The-Pope-Died-on-Sunday-english.xml: $(DOCBOOK5_XML_DIR)/The-Pope-Died-on-Sunday-english.xml
$(DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.txt: $(FICTION_XML_TXT_DIR)/The-Pope-Died-on-Sunday-hebrew.txt
$(DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.xml: $(DOCBOOK5_XML_DIR)/The-Pope-Died-on-Sunday-hebrew.xml
$(DEST_SPLAY_HHGG_STTNG): $(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng-hand-tweaked.txt
$(DEST__C_BAD_ELEMS_SRC): $(C_BAD_ELEMS_SRC)
$(DOCBOOK5_ALL_IN_ONE_XHTMLS_CSS): %/style.css: $(DOCMAKE_STYLE_CSS) %/all-in-one.html
$(DOCBOOK5_HHFG_IMAGES_DEST): $(DOCBOOK5_HHFG_DEST_DIR)/%: $(DOCBOOK5_BASE_DIR)/style/human-hacking-field-guide/% $(DOCBOOK5_HHFG_DEST_DIR)/index.xhtml
$(DOCBOOK5_INSTALLED_INDIVIDUAL_XHTMLS_CSS): %: $(DOCMAKE_STYLE_CSS)
$(DOCBOOK5_SOURCES_DIR)/hebrew-html-tutorial.xml: $(HTML_TUT_HEB_DB)
$(EXPANDER_JS_DEST): $(EXPANDER_JS_SRC)
$(FORTS_EPUB_DEST): $(FORTS_EPUB_SRC)
$(HHFG_HEB_V2_DEST): $(FICTION_XML_TXT_DIR)/human-hacking-field-guide-v2--hebrew.txt
$(HHFG_HEB_V2_XSLT_DEST): $(FICTION_XML_DB5_XSLT_DIR)/human-hacking-field-guide-hebrew-v2.xslt
$(HHFG_V2_IMAGES_DEST): $(HHFG_V2_IMAGES_DEST_DIR)/%: $(DOCBOOK5_BASE_DIR)/style/human-hacking-field-guide/% $(HHFG_V2_IMAGES_DEST_DIR)/index.xhtml
$(HHFG_V2_IMAGES_DEST_FROM_VCS): $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/%: $(DOCBOOK5_BASE_DIR)/style/human-hacking-field-guide/% $(HHFG_V2_IMAGES_DEST_DIR)/index.xhtml
$(HHGG_CONVERT_SCRIPT_DEST): $(HHGG_CONVERT_SCRIPT_SRC)
$(PUT_CARDS_2013_DEST): $(PUT_CARDS_2013_XHTML)
$(QOHELETH_IMAGES__DEST): $(QOHELETH_IMAGES__DEST_PREFIX)/%: $(QOHELETH_IMAGES__SOURCE_PREFIX)/%
$(QP_VIM_IFACE): lib/$(VIM_IFACE_BN)
$(SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS): $(T2_DEST)/%-pl.txt: $(T2_SRC_DIR)/%.pl
$(SELINA_MANDRAKE_ENG_FRON_IMAGE__DEST): $(SELINA_MANDRAKE_ENG_FRON_IMAGE__SOURCE)
$(SITE_SOURCE_INSTALL_TARGET): INSTALL.md
$(T2_DEST_FORTUNES_many_files): $(T2_DEST)/%: $(T2_SRC_DIR)/%
$(T2_DEST_FORTUNE_BOTTLE): $(T2_SRC_BOTTLE)
$(T2_FORTUNES_ALL__HTML): %/$(FORTUNES_ALL_IN_ONE__BASE): %/$(FORTUNES_ALL_IN_ONE__TEMP__BASE) fastrender-tt2
$(TERM_LIBERATION_IMAGES__DEST): $(TERM_LIBERATION_IMAGES__DEST_PREFIX)/%: $(TERM_LIBERATION_IMAGES__SOURCE_PREFIX)/%
common/js/jq.js: node_modules/jquery/dist/jquery.min.js
