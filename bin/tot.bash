./gen-helpers && make fastrender && make -j 17
dir=../temp-compare-out--to-del
mkdir -p "$dir"
adest="$dir/have.xhtml"
bdest="$dir/want.xhtml"
rm -f "$adest" "$bdest"
# for a in "dest/post-incs/t2/MathVentures/3d-outof-4d-mathml.xhtml"
for a in "dest/post-incs/t2/humour/All-in-an-Atypical-Day-Work/index.xhtml"
do
b=/home/shlomif/Arcs/temp/shlomif-homepage/post-$a
f()
{
    perl -lapE 's/</\n</g'
}
(echo "== $a == " ; f < $a ) >> $adest
(echo "== $a == " ; f < $b ) >> $bdest
done
gvimdiff $adest $bdest +colorscheme" apprentice" +"exe \"normal \\<c-w>J\""
