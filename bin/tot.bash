./gen-helpers && make fastrender && make -j 17
a="dest/post-incs/t2/philosophy/computers/web/which-wiki/update-2006-07/index.xhtml"
b=/home/shlomif/Backup/Arcs/post-$a
adest=have.xhtml
bdest=want.xhtml
tidy < $a > $adest
tidy < $b > $bdest
gvimdiff $adest $bdest +colorscheme" apprentice" +"exe \"normal \\<c-w>J\""
