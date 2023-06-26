SRC_MODS_DIR := lib/assets/mods

MODS := $(shell cd $(SRC_MODS_DIR) && ls *.{s3m,xm,mod})

ZIP_MODS := $(addsuffix .zip,$(MODS))
XZ_MODS := $(addsuffix .xz,$(MODS))

POST_DEST_MODS_DIR := $(POST_DEST)/Iglu/shlomif/mods
dest_mods = $(addprefix $(POST_DEST_MODS_DIR)/,$(1))
POST_DEST_ZIP_MODS := $(call dest_mods,$(ZIP_MODS))
POST_DEST_XZ_MODS := $(call dest_mods,$(XZ_MODS))
POST_DEST_ALL_MODS := $(POST_DEST_ZIP_MODS) $(POST_DEST_XZ_MODS)

mod_files: $(POST_DEST_ALL_MODS)

$(POST_DEST_XZ_MODS): $(POST_DEST_MODS_DIR)/%.xz: $(SRC_MODS_DIR)/%
	xz -9 --extreme < $< > $@

$(POST_DEST_ZIP_MODS): $(POST_DEST_MODS_DIR)/%.zip: $(SRC_MODS_DIR)/%
	TZ=UTC zip -joqX9 "$@" "$<"
