$(ALL_HTACCESSES): $(T2_DEST)/%/.htaccess: $(T2_SRC_DIR)/%/my_htaccess.conf
$(BK2HP_SVG_SRC): lib/repos/Shlomi-Fish-Back-to-my-Homepage-Logo/back-to-my-homepage-logo/back-to-my-homepage--scripted-final--with-gradient-applied--cropped.svg
$(DEST_INTERVIEWS)/ae-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/ae-interview.txt
$(DEST_INTERVIEWS)/sussman-interview.txt: $(SCREENPLAY_XML_TXT_DIR)/sussman-interview.txt
$(DEST_POPE)/The-Pope-Died-on-Sunday-english.txt: $(FICTION_XML_TXT_DIR)/The-Pope-Died-on-Sunday-english.txt
$(DEST_POPE)/The-Pope-Died-on-Sunday-english.xml: $(DOCBOOK5_XML_DIR)/The-Pope-Died-on-Sunday-english.xml
$(DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.txt: $(FICTION_XML_TXT_DIR)/The-Pope-Died-on-Sunday-hebrew.txt
$(DEST_POPE)/The-Pope-Died-on-Sunday-hebrew.xml: $(DOCBOOK5_XML_DIR)/The-Pope-Died-on-Sunday-hebrew.xml
$(DEST_SPLAY_HHGG_STTNG): $(SCREENPLAY_XML_TXT_DIR)/hitchhikers-guide-to-star-trek-tng-hand-tweaked.txt
$(DEST__C_BAD_ELEMS_SRC): $(C_BAD_ELEMS_SRC)
$(DOCBOOK4_ALL_IN_ONE_XHTMLS_CSS): %/style.css: $(DOCMAKE_STYLE_CSS) %/all-in-one.html
$(DOCBOOK4_HHFG_IMAGES_DEST): $(DOCBOOK4_HHFG_DEST_DIR)/%: $(DOCBOOK4_BASE_DIR)/style/human-hacking-field-guide/% $(DOCBOOK4_HHFG_DEST_DIR)/index.xhtml
$(DOCBOOK4_INSTALLED_INDIVIDUAL_XHTMLS_CSS): %: $(DOCMAKE_STYLE_CSS)
$(DOCBOOK5_SOURCES_DIR)/hebrew-html-tutorial.xml: $(HTML_TUT_HEB_DB)
$(EXPANDER_JS_DEST): $(EXPANDER_JS_SRC)
$(FORTS_EPUB_DEST): $(FORTS_EPUB_SRC)
$(GNU_slash_Linux_DEST): lib/repos/Captioned-Image-GNU-slash-Linux/gnu-slash-linux.svg.webp
$(HHFG_HEB_V2_DEST): $(FICTION_XML_TXT_DIR)/human-hacking-field-guide-v2--hebrew.txt
$(HHFG_HEB_V2_XSLT_DEST): $(FICTION_XML_DB5_XSLT_DIR)/human-hacking-field-guide-hebrew-v2.xslt
$(HHFG_V2_IMAGES_DEST): $(HHFG_V2_IMAGES_DEST_DIR)/%: $(DOCBOOK4_BASE_DIR)/style/human-hacking-field-guide/% $(HHFG_V2_IMAGES_DEST_DIR)/index.xhtml
$(HHFG_V2_IMAGES_DEST_FROM_VCS): $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/%: $(DOCBOOK4_BASE_DIR)/style/human-hacking-field-guide/% $(HHFG_V2_IMAGES_DEST_DIR)/index.xhtml
$(HHGG_CONVERT_SCRIPT_DEST): $(HHGG_CONVERT_SCRIPT_SRC)
$(Klingon_Warrior_Sesame_DEST): lib/repos/Captioned-Image-Every-mighty-Klingon-Warrior/Every-mighty-Klingon-Warrior.svg.webp
$(Nothing_Sexier_DEST): lib/repos/Captioned-Image-Nothing-Sexier/Nothing-Sexier.svg.webp
$(One_does_not_simply_cast_American_DEST): lib/repos/Captioned-Image-One-does-not-Simply-cast-an-American-Actress/one-does-not-simply-cast-an-american-actress.svg.webp
$(One_does_not_simply_set_up_email_service): lib/repos/Captioned-Image-One-does-not-Simply-set-up-an-Email-Service/one-does-not-simply-set-up-an-email-service.svg.webp
$(PUT_CARDS_2013_DEST): $(PUT_CARDS_2013_XHTML)
$(Philosophers_Pbride_DEST): lib/repos/Captioned-Image-Princess-Bride-Greek-Philosophers/philosophers-princess-bride.svg.webp
$(QOHELETH_IMAGES__DEST): $(QOHELETH_IMAGES__DEST_PREFIX)/%: $(QOHELETH_IMAGES__SOURCE_PREFIX)/%
$(QP_VIM_IFACE): lib/$(VIM_IFACE_BN)
$(SCRIPTS_WITH_OFFENDING_EXTENSIONS_TARGETS): $(T2_DEST)/%-pl.txt: $(T2_SRC_DIR)/%.pl
$(SELINA_MANDRAKE_ENG_FRON_IMAGE__DEST): $(SELINA_MANDRAKE_ENG_FRON_IMAGE__SOURCE)
$(SITE_SOURCE_INSTALL_TARGET): INSTALL.md
$(Slp_pinned_it_DEST): lib/repos/Captioned-Image-SLP-Pinned-It-On-Me/SLP-excerpt-pinned-it-on-me--400w.webp
$(T2_DEST_FORTUNES_many_files): $(T2_DEST)/%: $(T2_SRC_DIR)/%
$(T2_DEST_FORTUNE_BOTTLE): $(T2_SRC_BOTTLE)
$(T2_FORTUNES_ALL__HTML): %/$(FORTUNES_ALL_IN_ONE__BASE): %/$(FORTUNES_ALL_IN_ONE__TEMP__BASE) fastrender-tt2
$(TERM_LIBERATION_IMAGES__DEST): $(TERM_LIBERATION_IMAGES__DEST_PREFIX)/%: $(TERM_LIBERATION_IMAGES__SOURCE_PREFIX)/%
$(Truly_you_have_DEST): lib/repos/Captioned-Image-Truly-You-Have/Truly-You-Have.svg.webp
$(Yo_NSA_DEST): lib/repos/Captioned-Image-Yo-NSA-Publish-or-Perish/NSA-publish-or-perish.svg.webp
common/js/jq.js: node_modules/jquery/dist/jquery.min.js
t2/humour/Star-Trek/We-the-Living-Dead/images/fiery-Q.png: lib/screenplay-xml/from-vcs/Star-Trek--We-the-Living-Dead/star-trek--we-the-living-dead/graphics/Fiery-Q--no-background--one-layer--reduced.png
