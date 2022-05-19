HHFG_DIR := $(POST_DEST_HUMOUR)/human-hacking
HHFG_HEB_V2_TXT := human-hacking-field-guide-hebrew-v2.txt
HHFG_HEB_V2_POST_DEST := $(HHFG_DIR)/$(HHFG_HEB_V2_TXT)
HHFG_HEB_V2_XSLT_POST_DEST := $(HHFG_DIR)/human-hacking-field-guide-hebrew-v2.db-postproc.xslt

DOCBOOK5_HHFG_IMAGES_RAW := \
	background-image.png \
	background-shlomif.png \
	bottom-shlomif.png \
	hhfg-bg-bottom.png \
	hhfg-bg-middle.png \
	hhfg-bg-top.png \
	style.css \
	top-shlomif.png

DOCBOOK5_HHFG_DEST_DIR := $(PRE_DEST_HUMOUR)/human-hacking/human-hacking-field-guide
DOCBOOK5_HHFG_POST_DEST_DIR := $(POST_DEST_HUMOUR)/human-hacking/human-hacking-field-guide

HHFG_V2_IMAGES_DEST_DIR_FROM_VCS := $(PRE_DEST_HUMOUR)/human-hacking/human-hacking-field-guide-v2--english
HHFG_V2_IMAGES_DEST_DIR := $(PRE_DEST_HUMOUR)/human-hacking/human-hacking-field-guide-v2

HHFG_V2_IMAGES_POST_DEST_DIR_FROM_VCS := $(POST_DEST_HUMOUR)/human-hacking/human-hacking-field-guide-v2--english
HHFG_V2_IMAGES_POST_DEST_DIR := $(POST_DEST_HUMOUR)/human-hacking/human-hacking-field-guide-v2
HHFG_V2_IMAGES_POST_DEST := $(addprefix $(HHFG_V2_IMAGES_POST_DEST_DIR)/,$(DOCBOOK5_HHFG_IMAGES_RAW))
HHFG_V2_IMAGES_POST_DEST_FROM_VCS := $(addprefix $(HHFG_V2_IMAGES_POST_DEST_DIR_FROM_VCS)/,$(DOCBOOK5_HHFG_IMAGES_RAW))
HHFG_V2_DOCBOOK_css := $(HHFG_V2_IMAGES_POST_DEST_DIR)/docbook.css
DOCBOOK5_HHFG_IMAGES_POST_DEST := $(addprefix $(DOCBOOK5_HHFG_POST_DEST_DIR)/,$(DOCBOOK5_HHFG_IMAGES_RAW))

docbook_hhfg_images:  $(HHFG_V2_IMAGES_POST_DEST) $(HHFG_V2_IMAGES_POST_DEST_FROM_VCS) $(HHFG_V2_DOCBOOK_css) $(DOCBOOK5_HHFG_IMAGES_POST_DEST)

hhfg_fiction: $(HHFG_ENG_DOCBOOK5_SOURCE) $(HHFG_HEB_FICTION_XML_SOURCE)

$(HHFG_V2_DOCBOOK_css): lib/docbook/5/indiv-nodes/human-hacking-field-guide-v2--english/docbook.css
	$(MKDIR) $(HHFG_V2_IMAGES_POST_DEST_DIR)
	cp -f $< $@

$(HHFG_V2_IMAGES_DEST_DIR)/index.xhtml: $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/index.xhtml
	$(MKDIR) $(HHFG_V2_IMAGES_DEST_DIR)
	cp -a $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS)/*.xhtml $(HHFG_V2_IMAGES_DEST_DIR)/

HHFG_SMALL_BANNER_AD_PNG := $(POST_DEST_HUMOUR)/human-hacking/images/hhfg-ad-468x60.svg.preview.png
