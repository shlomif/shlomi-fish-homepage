./gen-helpers && make fastrender && make -j 17
a="dest/post-incs/t2/humour/Summerschool-at-the-NSA/ongoing-text.html"
b=/home/shlomif/Backup/Arcs/post-$a
adest=have.xhtml
bdest=want.xhtml
f()
{
    perl -lapE 's/</\n</g'
}
f < $a > $adest
f < $b > $bdest
gvimdiff $adest $bdest +colorscheme" apprentice" +"exe \"normal \\<c-w>J\""
