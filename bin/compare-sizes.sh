ls dest/post-incs/t2/**.min.svg | perl -ln -E '$m=$_;$o=s/\.min.svg\z/.o.svg/mrs;$d=((-s $m) - (-s $o));printf "%d\t%s\n", ($d), $_;' | sort -n | less
