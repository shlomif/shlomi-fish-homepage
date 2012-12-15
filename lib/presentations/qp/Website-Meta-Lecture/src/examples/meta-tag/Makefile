D = dest

TARGETS = $(D)/index.html $(D)/links.html $(D)/download.html
IMAGES = $(D)/style.css

all: $(TARGETS) $(IMAGES)

# This flag makes sure WML generates XHTML output
WML_FLAGS = --passoption=2,-X

# This flag sets ROOT to be the current directory
WML_FLAGS += -D ROOT~.

$(TARGETS) :: $(D)/% : %.wml template.wml
	wml $(WML_FLAGS) -DFILENAME="$(notdir $@)" $< > $@

$(IMAGES) :: $(D)/% : %
	cp -f $< $@

