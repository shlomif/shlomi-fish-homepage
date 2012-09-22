#!/bin/bash
find dest/t2-homepage/ -name '*.html' -or -name '*.xhtml' |
    ( LC_ALL=C sort  ) |
    perl -lne 'print if 1..m#open-source/projects/yjobs-on-mozilla#' |
    grep -vP 'guide2ee/undergrad' |
    grep -vP '(?:humour/TheEnemy/(?:The-Enemy-(?:English-)?rev|TheEnemy))' |
    grep -vP '(?:humour/by-others/(?:English-is-a-Crazy-Language|darien|hitchhiker|how-many-newsgroup-readers|oded-c|s-stands-for-simple|technion-bit-1|top-12-things-likely|was-the-death-star-attack|grad-student-jokes-from-jnoakes))' |
    grep -vP 'humour/fortunes' |
    grep -vP 'humour/human-hacking/.*arabic' |
    grep -vP 'humour/human-hacking/human-hacking-field-guide/' |
    grep -vP 'humour/human-hacking/hebrew-v2' |
    grep -vP 'humour/humanity/ongoing-text-hebrew' |
    grep -vP 'lecture/Lambda-Calculus/slides/shriram\.scm' |
    xargs perl bin/html-check-spelling-xmlp.pl |
    grep ':'
    # perl -lne 'print if /MathVentures\/3d.*\.xhtml/' |
exit 0
