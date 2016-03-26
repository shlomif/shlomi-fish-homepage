D = dest

TARGETS = $(D)/index.html $(D)/links.html $(D)/download.html
IMAGES = $(D)/style.css $(D)/frames.html

all: $(TARGETS) $(IMAGES) $(D)/navbar-frame.html

# This flag makes sure WML generates XHTML output
WML_FLAGS = --passoption=2,-X

# This flag sets ROOT to be the current directory
WML_FLAGS += -D ROOT~.

$(D)/navbar-frame.html : navbar-frame.html.wml
	wml $(WML_FLAGS) -o $@ $<

$(TARGETS) :: $(D)/% : %.wml template.wml
	wml $(WML_FLAGS) -o UNDEF+NOFRAMES:$@ -o UNDEF+FRAMES:$@.frames.html -DFILENAME="$(notdir $@)" $<

$(IMAGES) :: $(D)/% : %
	cp -f $< $@

