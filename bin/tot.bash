./gen-helpers && make fastrender && make -j 17
a="dest/post-incs/t2/open-source/projects/japanese-puzzle-games/kakurasu/index.xhtml"
b=/home/shlomif/Backup/Arcs/post-$a
dir=../temp-compare-out--to-del
mkdir -p "$dir"
adest="$dir/have.xhtml"
bdest="$dir/want.xhtml"
f()
{
    perl -lapE 's/</\n</g'
}
f < $a > $adest
f < $b > $bdest
gvimdiff $adest $bdest +colorscheme" apprentice" +"exe \"normal \\<c-w>J\""
