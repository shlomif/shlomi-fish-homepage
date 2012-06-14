 find . -name '*.html' |
	(while read T ; do
		cat $T |
			sed 's/<b>/<tt>/g' |
			sed 's/<\/b>/<\/tt>/'g |
			sed 's/<u>/<b>/g' |
			sed 's/<\/u>/<\/b>/g' > $T.temp ;
	done)
