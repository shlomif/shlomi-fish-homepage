FACTOIDS_RENDER_SCRIPT := $(LATEMP_ROOT_SOURCE_DIR)/lib/factoids/gen-html.pl
FACTOIDS_TIMESTAMP := lib/factoids/TIMESTAMP
FACTOIDS_GEN_CMD := $(PERL) $(FACTOIDS_RENDER_SCRIPT)
PYTHON := python3

$(FACTOIDS_TIMESTAMP): $(FACTOIDS_RENDER_SCRIPT) lib/factoids/shlomif-factoids-lists.xml
	$(FACTOIDS_GEN_CMD)

all_deps: $(FACTOIDS_TIMESTAMP)

FACTOIDS_NAV_JSON := lib/Shlomif/factoids-nav.json

src/humour/fortunes/shlomif-factoids.xml: lib/factoids/merge_into_fortunes.py src/humour/fortunes/proto--shlomif-factoids.xml lib/factoids/shlomif-factoids-lists.xml
	$(PYTHON) $<

$(FACTOIDS_NAV_JSON):
	$(FACTOIDS_GEN_CMD)
