VER = 0.10.11

DIST_BASE = fortunes-shlomif

DIST_DIR = $(DIST_BASE)-$(VER)

PACKAGE_BASE = $(DIST_DIR).tar.gz

FILES = \
	friends \
	joel-on-software \
	nyh-sigs \
	osp_rules \
	paul-graham \
	shlomif \
	shlomif-fav \
	subversion \
	tinic

DATS = $(addsuffix .dat,$(FILES))

INDEX_FILE = index.html

VERSION_FILE = ver.txt

all: dist test

$(DATS):: %.dat : %
	PATH="$$PATH:/usr/sbin" strfile $<

test: $(DATS)
	@fortune -e $(FILES)
	
dist: $(PACKAGE_BASE)

html: $(INDEX_FILE)

$(PACKAGE_BASE): $(DATS) Makefile $(VERSION_FILE)
	mkdir $(DIST_DIR)
	cp $(FILES) $(DATS) Makefile $(DIST_DIR)
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

