DB = D.pm
S = shlom.in-refer.pl
dest = dest/1

all: $(DB)

$(DB): gen-db.pl
	perl $<

minify = perltidy --mangle -dac

dests:
	$(minify) < $(DB) > $(dest)/$(DB)
	$(minify) < $(S) > $(dest)/$(S)
	chmod a+x $(dest)/$(S)

upload: dests
	rsync -a -v --progress $(dest)/$(S) $(dest)/$(DB) hostgator:shlom.in/public_html/

test: all
	prove t/*.t

check: test
