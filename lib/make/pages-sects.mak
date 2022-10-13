FAQ_SECTS__DIR := $(POST_DEST)/meta/FAQ
FAQ_SECTS__PIVOT := $(FAQ_SECTS__DIR)/diet.xhtml
FAQ_SECTS__SRC := $(FAQ_SECTS__DIR)/index.xhtml
FAQ_SECTS__PROGRAM := lib/split-html/splitter_prog.py
FAQ_SECTS__LIB_DEPS := lib/split-html/split_into_sections.py
IMAGE_MACRO_SECTS__DIR := $(POST_DEST)/humour/image-macros
IMAGE_MACRO_SECTS__SRC := $(IMAGE_MACRO_SECTS__DIR)/index.xhtml
IMAGE_MACRO_SECTS__DEST_DIR := $(IMAGE_MACRO_SECTS__DIR)/indiv-nodes

process_sects_dir = (cd $(1) && ls *.xhtml) | $(call PROC_INCLUDES_COMMON2,$(1),$(1))

$(FAQ_SECTS__PIVOT): $(FAQ_SECTS__PROGRAM) $(FAQ_SECTS__LIB_DEPS) $(IMAGE_MACRO_SECTS__SRC)
	$(PYTHON) $(FAQ_SECTS__PROGRAM)
	touch $@
	$(call process_sects_dir,$(FAQ_SECTS__DIR))
	$(call process_sects_dir,$(IMAGE_MACRO_SECTS__DEST_DIR))

$(FAQ_SECTS__SRC) $(IMAGE_MACRO_SECTS__SRC): $(SRC_CLEAN_STAMP)

post_latemp_deps: $(FAQ_SECTS__PIVOT)
