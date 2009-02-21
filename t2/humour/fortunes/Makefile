include fortunes-list.mak

VER = 0.10.134

DIST_BASE = fortunes-shlomif

DIST_DIR = $(DIST_BASE)-$(VER)

PACKAGE_BASE = $(DIST_DIR).tar.gz

FILES = $(FORTUNES_FILES_BASE)

DATS = $(addsuffix .dat,$(FILES))

XMLS = $(addsuffix .xml,$(FILES))

XHTMLS = $(patsubst %.xml,%.xhtml,$(XMLS))

INDEX_FILE = index.html

VERSION_FILE = ver.txt

.PHONY: all test html distdir upload list_files

all: dist test

$(DATS):: %.dat : %
	PATH="$$PATH:/usr/sbin" strfile $<

test: $(DATS)
	@fortune -e $(FILES)
	
dist: $(PACKAGE_BASE) list_files

html: $(INDEX_FILE)

EXTRA_FILES = Makefile fortunes-list.mak

PACKAGE_DEPS = $(DATS) $(EXTRA_FILES) $(VERSION_FILE)

distdir: $(DIST_DIR)

$(DIST_DIR): $(PACKAGE_DEPS)
	mkdir $(DIST_DIR)
	cp $(FILES) $(DATS) $(EXTRA_FILES) $(DIST_DIR)

$(PACKAGE_BASE): $(PACKAGE_DEPS)
	@make distdir
	tar -czvf $(PACKAGE_BASE) $(DIST_DIR)
	rm -fr $(DIST_DIR)

$(INDEX_FILE): fortunes-index.html $(PACKAGE_BASE)
	cat $< | sed '/%%PACKAGE_BASE%%/ s/href=".*"/href="$(PACKAGE_BASE)"/' > $@

$(VERSION_FILE): Makefile
	echo $(VER) > $@

upload: dist
	rsync -r -v --progress $(DATS) $(FILES) $(PACKAGE_BASE) $(INDEX_FILE) "$${HOMEPAGE_SSH_PATH}/Vipe/humour/fortunes/" 

print_package_base:
	@echo $(PACKAGE_BASE)

ARCS_LIST_INCLUDE = arcs-list.mak

list_files: $(ARCS_LIST_INCLUDE)

$(ARCS_LIST_INCLUDE): $(VERSION_FILE)
	@perl -le 'print "FORTUNES_ARCS_LIST = " . join(" ", glob("fortunes-shlomif-*.tar.gz"))' > $@

xhtmls: $(XHTMLS)

$(XHTMLS): %.xhtml: %.xml convert-to-xhtml.pl
	bash run-validator.bash $< $@
	perl convert-to-xhtml.pl $<
	touch $(patsubst %.xml,%.html.wml,$<)

%.show:
	@echo "$* = $($*)"
