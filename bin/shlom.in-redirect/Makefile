DB = D.pm

all: $(DB)

$(DB): gen-db.pl
	perl $<

upload: all
	rsync -a -v --progress "shlom.in-refer.pl" $(DB) hostgator:shlom.in/public_html/

test: all
	prove t/*.t

check: test
