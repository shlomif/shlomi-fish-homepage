LATEMP_WML_FLAGS =$(shell latemp-config --wml-flags)

WML_FLAGS += --passoption=2,-X3074 --passoption=3,-I../lib/ \
	--passoption=3,-w -I../lib/ $(LATEMP_WML_FLAGS) \
	-DROOT~. -DLATEMP_THEME=better-scm

ALL_DEST_BASE = dest

FORTUNES_TARGET = dest/vipe-homepage/humour/fortunes/fortunes-index.html

DOCS_COMMON_DEPS = template.wml lib/MyNavData.pm

all: latemp_targets $(FORTUNES_TARGET)
	
include include.mak
include rules.mak

# t2 macros

RSYNC = rsync --progress --verbose --rsh=ssh

upload_t2: $(T2_TARGETS)
	( cd $(T2_DEST) && $(RSYNC) -r * shlomif@iglu.org.il:Home-Site/ )

upload_vipe: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * shlomif@vipe.technion.ac.il:public_html/ )

upload_t2_temp: $(T2_TARGETS)
	( cd $(T2_DEST) && $(RSYNC) -r * shlomif@iglu.org.il:Home-Site/__New-Site/shlomif/ )

upload_vipe_temp: $(VIPE_TARGETS)
	( cd $(VIPE_DEST) && $(RSYNC) -r * shlomif@iglu.org.il:Home-Site/__New-Site/vipe/ )

# upload: upload_t2_temp upload_vipe_temp
upload: upload_t2 upload_vipe

clean:
	rm -fr $(T2_DEST)/*
	rm -fr $(VIPE_DEST)/*

t2/SFresume.html.wml : lib/SFresume_base.wml
	touch $@

t2/SFresume_detailed.html.wml : lib/SFresume_base.wml
	touch $@

PHILOSOPHY_DEPS = lib/sub-menus/essays.wml lib/MyEssaysNavData.pm
LECTURES_DEPS = lib/sub-menus/lectures.wml lib/MyLecturesNavData.pm

t2/philosophy/Index/index.html.wml : lib/article-index/article-index.dtd lib/article-index/article-index.xml lib/article-index/article-index.xsl $(PHILOSOPHY_DEPS)
	touch $@

$(FORTUNES_TARGET): vipe/humour/fortunes/fortunes-index.html.wml $(DOCS_COMMON_DEPS)
	( cd vipe && wml $(WML_FLAGS) -DLATEMP_SERVER=vipe -DLATEMP_FILENAME=humour/fortunes/index.html humour/fortunes/fortunes-index.html.wml ) > $@

T2_DOCS_SRC = $(patsubst $(T2_DEST)/%,$(T2_SRC_DIR)/%.wml,$(T2_DOCS_DEST))
VIPE_DOCS_SRC = $(patsubst $(VIPE_DEST)/%,$(VIPE_SRC_DIR)/%.wml,$(VIPE_DOCS_DEST))

T2_PHILOSOPHY_DOCS_SRC = $(filter-out $(T2_SRC_DIR)/philosophy/Index/%,$(filter $(T2_SRC_DIR)/philosophy/%,$(T2_DOCS_SRC)))

$(T2_PHILOSOPHY_DOCS_SRC):: $(T2_SRC_DIR)/philosophy/%.html.wml: $(PHILOSOPHY_DEPS)
	touch $@

T2_LECTURES_DOCS_SRC = $(filter $(T2_SRC_DIR)/lecture/%,$(T2_DOCS_SRC))

$(T2_LECTURES_DOCS_SRC):: $(T2_SRC_DIR)/lectures/%.html.wml: $(LECTURES_DEPS)
	touch $@

VIPE_LECTURES_DOCS_SRC = $(filter $(VIPE_SRC_DIR)/lecture/%,$(VIPE_DOCS_SRC))

$(VIPE_LECTURES_DOCS_SRC):: $(VIPE_SRC_DIR)/lecture/%.html.wml: $(LECTURES_DEPS)
	touch $@

