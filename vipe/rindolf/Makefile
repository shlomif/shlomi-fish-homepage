BASE = rindolf-spec

all: $(BASE).html $(BASE).txt

$(BASE).html: $(BASE).pod
	pod2html $< > $@

$(BASE).txt: $(BASE).pod
	pod2text $< > $@
