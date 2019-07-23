./gen-helpers&& make fastrender&& make -j 17
a=dest/post-incs/t2/wonderous.html; b=/home/shlomif/Backup/Arcs/post-$a; tidy < $a > $a.xhtml ; tidy < $b > $b.xhtml ; gvimdiff $a.xhtml $b.xhtml  +colorscheme" apprentice" +"exe \"normal \\<c-w>J\""
