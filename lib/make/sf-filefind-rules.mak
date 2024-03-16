COMMON_SRC_DIR = common


SRC_SRC_DIR := src

SRC_DEST := dest/pre-incs/t2

SRC_DOCS_DEST := $(patsubst %,$(SRC_DEST)/%,$(SRC_DOCS))

SRC_DIRS_DEST := $(patsubst %,$(SRC_DEST)/%,$(SRC_DIRS))

SRC_IMAGES_DEST := $(patsubst %,$(POST_DEST)/%,$(SRC_IMAGES))

SRC_COMMON_IMAGES_DEST := $(patsubst %,$(POST_DEST)/%,$(COMMON_IMAGES))

SRC_COMMON_DIRS_DEST := $(patsubst %,$(SRC_DEST)/%,$(COMMON_DIRS))

SRC_COMMON_DOCS_DEST := $(patsubst %,$(SRC_DEST)/%,$(COMMON_DOCS))

$(SRC_DOCS_DEST) : $(SRC_DEST)/% : $(SRC_SRC_DIR)/%.tt2 $(DOCS_COMMON_DEPS)
	$(call SRC_INCLUDE_TT2_RENDER)

$(SRC_DIRS_DEST) : $(SRC_DEST)/% :
	mkdir -p $@
	touch $@

$(SRC_IMAGES_DEST) : $(POST_DEST)/% : $(SRC_SRC_DIR)/%
	$(call LATEMP_COPY)

$(SRC_COMMON_IMAGES_DEST) : $(POST_DEST)/% : $(COMMON_SRC_DIR)/%
	$(call LATEMP_COPY)

$(SRC_COMMON_DOCS_DEST) : $(SRC_DEST)/% : $(COMMON_SRC_DIR)/%.tt2 $(DOCS_COMMON_DEPS)
	$(call SRC_COMMON_INCLUDE_TT2_RENDER)

$(SRC_COMMON_DIRS_DEST)  : $(SRC_DEST)/% :
	mkdir -p $@
	touch $@

$(SRC_DEST):
	mkdir -p $@
	touch $@
latemp_targets: $(SRC_TARGETS)

