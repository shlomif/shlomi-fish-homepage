find . -name '*.html.wml' |
    (while read T ; do
        mv -f $T $T.old ;
        cat $T.old |
            perl -e 'my $text = join("",<>); $text =~ s!<a href="http://www.tuxedo.org/~esr/([^"]*)">([^<]*)</a>!<esr:homesite:link href="$1">$2</esr:homesite:link>!gm; print $text;' > $T
    done
    )

    # sed 's!<a href="http://www.tuxedo.org/~esr/([^"]*)">([^<]*)</a>!<esr:homesite:link htef="\1">\2</esr:homesite:link>!g'

