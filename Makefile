
T2_DOCS = $(shell bash find-wmls-t2.sh)

T2_DEST = /var/www/html/shlomi/t2-homepage

WML_FLAGS += --passoption=2,-X

T2_WML_FLAGS = $(WML_FLAGS) -DROOT~. -DVIPE_URL="/shlomi/vipe-homepage"

T2_DOCS_DEST = $(patsubst t2/%.wml,$(T2_DEST)/%,$(T2_DOCS))

T2_DIRS_RAW = $(shell find t2 -type d)

T2_DIRS = $(addprefix t2/,$(T2_DIRS_RAW))

T2_DIRS_DEST = $(patsubst t2/%,$(T2_DEST)/%,$(T2_DIRS))

T2_IMAGES = $(shell find t2 -type f -not -name '*.wml' | grep -v '/\.svn')

all:
	echo $(T2_IMAGES)

T2_IMAGES_DEST = $(patsubst t2/%,$(T2_DEST)/%,$(T2_IMAGES))


all: $(T2_DIRS_DEST) $(T2_DOCS_DEST) $(T2_DEST)/style.css $(T2_IMAGES_DEST)




$(T2_DOCS_DEST) :: $(T2_DEST)/% : t2/%.wml template.wml t2/.wmlrc
	( cd t2 && wml $(WML_FLAGS) -DFILENAME=$(patsubst $(T2_DEST)/%,%,$(patsubst %.wml,%,$@)) $(patsubst t2/%,%,$<) > $@ )

$(T2_DIRS_DEST) :: $(T2_DEST)/% : t2/%
	mkdir -p $@

$(T2_IMAGES_DEST) :: $(T2_DEST)/% : t2/%
	cp -f $< $@

$(T2_DEST)/style.css : style.css
	cp -f $< $@

