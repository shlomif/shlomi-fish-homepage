all: image_files

BIZCARD_SVG_INPUT_BN := bizcard.svg
BIZCARD_SVG_OUTPUT_BN := embedded-png-bizcard.svg
SRC_SRC_DIR := src
BIZCARD_SVG_DIR := $(SRC_SRC_DIR)/me/images
BIZCARD_SVG_OUTPUT_PATH := $(BIZCARD_SVG_DIR)/$(BIZCARD_SVG_OUTPUT_BN)

INKSCAPE_EXT_PATH := /usr/share/inkscape/extensions

$(BIZCARD_SVG_OUTPUT_PATH): $(BIZCARD_SVG_DIR)/$(BIZCARD_SVG_INPUT_BN)
	( set -e -x ; inkscape_ext_path="$(INKSCAPE_EXT_PATH)" ; if test -n "$${PYTHONPATH}" ; then export PYTHONPATH="$$PYTHONPATH:" ; fi ; export PYTHONPATH="$$PYTHONPATH:$$inkscape_ext_path" ; d="`pwd`" ; md="$${d}/$(BIZCARD_SVG_DIR)" ; HOME="$${md}" python3 "$${inkscape_ext_path}"/image_embed.py "$<" > "$@" )

image_files: $(BIZCARD_SVG_OUTPUT_PATH)
