COMMON_POST_DEST_DIRS := $(addprefix $(POST_DEST)/,$(COMMON_DIRS))
ALL_DIRS__TO_make_dirs := $(COMMON_POST_DEST_DIRS) $(DOCBOOK5_ALL_IN_ONE_XHTMLS__DIRS) $(DOCBOOK5_INDIVIDUAL_XHTML__POST_DEST__DIRS) $(HHFG_V2_IMAGES_DEST_DIR) $(HHFG_V2_IMAGES_DEST_DIR_FROM_VCS) $(HHFG_V2_IMAGES_POST_DEST_DIR) $(POST_DEST_DIRS)
ALL_DIRS := $(ALL_DIRS__TO_make_dirs) $(HHFG_V2_IMAGES_POST_DEST_DIR_FROM_VCS) $(SRC_COMMON_DIRS_DEST) $(SRC_DIRS_DEST)

bulk-make-dirs:
	@$(MKDIR) $(ALL_DIRS)

make-dirs: $(ALL_DIRS)

$(ALL_DIRS__TO_make_dirs): %:
	$(MKDIR) $@
	touch $@
