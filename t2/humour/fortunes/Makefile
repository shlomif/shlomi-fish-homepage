include fortunes-list.mak

T2_FORTUNES_DIR = .
PERL = perl
FORTUNES_PERL := perl -I. -MShlomifFortunesMake -e
VERSION_FILE := $(shell $(FORTUNES_PERL) 'print ShlomifFortunesMake->version_file;')

VER := $(shell $(FORTUNES_PERL) 'print ShlomifFortunesMake->ver;')

DIST_BASE := $(shell $(FORTUNES_PERL) 'print ShlomifFortunesMake->dist_base;')

INDEX_FILE := index.html

SOURCE_FILES_LIST := source-files-list.html

RPM_SPEC := $(DIST_BASE).spec
RPM_SPEC_IN := $(RPM_SPEC).in

DIST_DIR := $(shell $(FORTUNES_PERL) 'print ShlomifFortunesMake->dist_dir;')

PACKAGE_BASE := $(shell $(FORTUNES_PERL) 'print ShlomifFortunesMake->package_base;')

FILES := $(FORTUNES_FILES_BASE)

DATS := $(addsuffix .dat,$(FILES))

XMLS := $(addsuffix .xml,$(FILES))

XHTMLS := $(patsubst %.xml,%.xhtml,$(XMLS))


.PHONY: all test html distdir upload

all: dist test gen_htaccess

$(DATS):: %.dat : %
	PATH="$$PATH:/usr/sbin" strfile $<

dats: $(DATS)

test: $(DATS)
	@fortune -e $(FILES)

dist: $(PACKAGE_BASE) gen_sources_list

html: $(INDEX_FILE)

EXTRA_FILES = Makefile fortunes-list.mak $(RPM_SPEC) $(RPM_SPEC_IN)

PACKAGE_DEPS = $(DATS) $(EXTRA_FILES) $(VERSION_FILE)

distdir: $(DIST_DIR)

$(DIST_DIR): $(PACKAGE_DEPS)
	mkdir $(DIST_DIR)
	cp $(FILES) $(DATS) $(EXTRA_FILES) $(DIST_DIR)

$(PACKAGE_BASE): $(PACKAGE_DEPS)
	if test -e $@ ; then \
		echo "Error! Cannot overwrite an existing archive. Please bump the version" 1>&2 ;\
		exit -1 ;\
	fi
	@make distdir
	tar -czvf $@ $(DIST_DIR)
	rm -fr $(DIST_DIR)

$(INDEX_FILE): fortunes-index.html $(PACKAGE_BASE)
	cat $< | sed '/%%PACKAGE_BASE%%/ s/href=".*"/href="$(PACKAGE_BASE)"/' > $@

upload: dist
	rsync -r -v --progress $(DATS) $(FILES) $(PACKAGE_BASE) $(INDEX_FILE) "$${HOMEPAGE_SSH_PATH}/Vipe/humour/fortunes/"

print_package_base:
	@echo $(PACKAGE_BASE)

xhtmls: $(XHTMLS)

$(XHTMLS): %.xhtml: %.xml convert-to-xhtml.pl
	bash run-validator.bash $< $@
	perl convert-to-xhtml.pl $<
	touch $(patsubst %.xml,%.html.wml,$<)

$(FILES): %: %.xml
	bash $(T2_FORTUNES_DIR)/run-validator.bash $< && \
	$(PERL) $(T2_FORTUNES_DIR)/convert-to-plaintext.pl $< $@

gen_sources_list: $(SOURCE_FILES_LIST)

$(SOURCE_FILES_LIST): generate-file-list.pl
	perl $<

$(RPM_SPEC): $(RPM_SPEC_IN) $(VERSION_FILE)
	perl update-spec.pl -i $< -o $@ --ver $(VER)

%.show:
	@echo "$* = $($*)"

gen_htaccess: my_htaccess.conf

my_htaccess.conf: gen-htaccess.pl fortunes-list.mak
	perl $< -o $@ $(FILES)
