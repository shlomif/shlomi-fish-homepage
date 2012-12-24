include fortunes-list.mak

VERSION_FILE = ver.txt

VER = $(shell head -1 $(VERSION_FILE))

DIST_BASE = fortunes-shlomif

INDEX_FILE = index.html

ARCS_LIST_INCLUDE = arcs-list.mak

SOURCE_FILES_LIST = source-files-list.html

RPM_SPEC = $(DIST_BASE).spec
RPM_SPEC_IN = $(RPM_SPEC).in

DIST_DIR = $(DIST_BASE)-$(VER)

PACKAGE_BASE = $(DIST_DIR).tar.gz

FILES = $(FORTUNES_FILES_BASE)

DATS = $(addsuffix .dat,$(FILES))

XMLS = $(addsuffix .xml,$(FILES))

XHTMLS = $(patsubst %.xml,%.xhtml,$(XMLS))


.PHONY: all test html distdir upload list_files

all: dist test gen_htaccess

$(DATS):: %.dat : %
	PATH="$$PATH:/usr/sbin" strfile $<

test: $(DATS)
	@fortune -e $(FILES)

dist: $(PACKAGE_BASE) list_files gen_sources_list

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

list_files: $(ARCS_LIST_INCLUDE)

$(ARCS_LIST_INCLUDE): $(VERSION_FILE)
	@perl -le 'print "FORTUNES_ARCS_LIST = " . join(" ", glob("fortunes-shlomif-*.tar.gz"))' > $@

xhtmls: $(XHTMLS)

$(XHTMLS): %.xhtml: %.xml convert-to-xhtml.pl
	bash run-validator.bash $< $@
	perl convert-to-xhtml.pl $<
	touch $(patsubst %.xml,%.html.wml,$<)

gen_sources_list: $(SOURCE_FILES_LIST)

$(SOURCE_FILES_LIST): generate-file-list.pl $(ARCS_LIST_INCLUDE)
	perl $<

$(RPM_SPEC): $(RPM_SPEC_IN) $(VERSION_FILE)
	perl update-spec.pl -i $< -o $@ --ver $(VER)

%.show:
	@echo "$* = $($*)"

gen_htaccess: my_htaccess.conf

my_htaccess.conf: gen-htaccess.pl fortunes-list.mak
	perl $< -o $@ $(FILES)
