f() {python3 bin/extract-docbook5-node.py "$1" '//xhtml:main' |pandoc; }; ( f "dest/post-incs/t2/meta/FAQ/which_disabilities_do_you_have.xhtml"; f "dest/post-incs/t2/meta/FAQ/advertise_your_site.xhtml"; ) | fpaste -o
