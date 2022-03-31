include fortunes-list.mak

T2_FORTUNES_DIR = .
PERL = perl
FORTUNES_PERL := perl -I. -MShlomifFortunesMake -e
perlfunc = $(shell $(FORTUNES_PERL) 'print ShlomifFortunesMake->$1();')
VERSION_FILE := $(perlfunc version_file)
:
VER := $(call perlfunc,ver)

DIST_BASE := $(call perlfunc,dist_base)

SOURCE_FILES_LIST := source-files-list.html

RPM_SPEC := $(DIST_BASE).spec
RPM_SPEC_IN := $(RPM_SPEC).in

DIST_DIR := $(call perlfunc,dist_dir)

PACKAGE_BASE := $(call perlfunc,package_base)

FILES := $(FORTUNES_FILES_BASE)

DATS := $(addsuffix .dat,$(FILES))

XMLS := $(addsuffix .xml,$(FILES))

XHTMLS := $(patsubst %.xml,%.xhtml,$(XMLS))


.PHONY: all test html distdir upload

all: test gen_htaccess

$(DATS):: %.dat : %
	PATH="$$PATH:/usr/sbin" strfile -s $<

dats: $(DATS)

test: $(DATS)
	@fortune -e $(FILES) > /dev/null

dist: $(PACKAGE_BASE) gen_sources_list

EXTRA_FILES = Makefile fortunes-list.mak $(RPM_SPEC) $(RPM_SPEC_IN)

PACKAGE_DEPS = $(DATS) $(EXTRA_FILES) $(VERSION_FILE)

distdir: $(DIST_DIR)

$(DIST_DIR): $(PACKAGE_DEPS)
	mkdir $(DIST_DIR)
	rsync -a $(FILES) $(DATS) $(EXTRA_FILES) $(DIST_DIR)/

$(PACKAGE_BASE): $(PACKAGE_DEPS)
	if test -e $@ ; then \
		echo "Error! Cannot overwrite an existing archive. Please bump the version" 1>&2 ;\
		exit -1 ;\
	fi
	@make distdir
	touch -t 202006241200.00 $(DIST_DIR)
	XZ_OPT="-9 --extreme" tar --group=user:1000 --owner=user:1000 --sort=name -caf $@ $(DIST_DIR)
	rm -fr $(DIST_DIR)

print_package_base:
	@echo $(PACKAGE_BASE)

xhtmls: $(XHTMLS)

$(XHTMLS): %.xhtml: %.xml
	$(PERL) $(T2_FORTUNES_DIR)/convert-to-xhtml.pl $<

$(FILES): %: %.xml
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
