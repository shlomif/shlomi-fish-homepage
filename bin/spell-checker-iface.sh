#!/bin/bash
find dest/t2-homepage/ -name '*.html' -or -name '*.xhtml' |
    ( LC_ALL=C sort  ) |
    perl -lne 'print if 1..m#humour/TheEnemy/The-Enemy-English-v7#'|
    grep -vP '(guide2ee/undergrad)' |
    grep -vP '(humour/TheEnemy/The-Enemy-(?:English-)?rev)' |
    xargs perl bin/html-check-spelling-xmlp.pl |
    grep ':'
    # perl -lne 'print if /MathVentures\/3d.*\.xhtml/' |
exit 0
