
T2_DOCS = $(shell bash find-wmls-t2.sh)

T2_DEST_BASE = /var/www/html/shlomi/
T2_DEST_DIR = t2-homepage
T2_DEST = $(T2_DEST_BASE)$(T2_DEST_DIR)

WML_FLAGS += --passoption=2,-X

T2_WML_FLAGS = $(WML_FLAGS) -DROOT~. -DVIPE_URL="/shlomi/vipe-homepage"

T2_DOCS_DEST = $(patsubst t2/%.wml,$(T2_DEST)/%,$(T2_DOCS))

T2_DIRS = $(shell find t2 -type d | grep -v '/\.svn' | grep -v '^\.svn' | tail +2)

T2_DIRS_DEST = $(patsubst t2/%,$(T2_DEST)/%,$(T2_DIRS))

T2_IMAGES = $(shell find t2 -type f -not -name '*.wml' | grep -v '/\.svn' | grep -v '~$$')

T2_IMAGES_DEST = $(patsubst t2/%,$(T2_DEST)/%,$(T2_IMAGES))


all: $(T2_DIRS_DEST) $(T2_DOCS_DEST) $(T2_DEST)/style.css $(T2_IMAGES_DEST)
#all: $(T2_DIRS_DEST) $(T2_DOCS_DEST) 

RSYNC = rsync --progress --verbose --rsh=ssh

upload: all
	echo T2_DEST = $(T2_DEST)
	( cd $(T2_DEST) && $(RSYNC) -r * shlomif@t2.technion.ac.il:public_html/ )

$(T2_DOCS_DEST) :: $(T2_DEST)/% : t2/%.wml template.wml t2/.wmlrc
	( cd t2 && wml $(WML_FLAGS) -DFILENAME=$(patsubst $(T2_DEST)/%,%,$(patsubst %.wml,%,$@)) $(patsubst t2/%,%,$<) > $@ )

$(T2_DIRS_DEST) :: $(T2_DEST)/% : t2/%
	mkdir -p $@

$(T2_IMAGES_DEST) :: $(T2_DEST)/% : t2/%
	cp -f $< $@

$(T2_DEST)/style.css : style.css
	cp -f $< $@

