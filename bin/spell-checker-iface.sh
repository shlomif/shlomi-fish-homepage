#!/bin/bash
find dest/t2/ -name '*.html' -or -name '*.xhtml' |
    ( LC_ALL=C sort  ) |
    grep -vP 'dest/t2/philosophy/obj-oss/objectivism-and-open-source/' |
    grep -vP '^dest/t2/MANIFEST\.html$' |
    grep -vP 'philosophy/foss-other-beasts/revision-2/' |
    grep -vP 'philosophy/politics/drug-legalisation/case-for-drug-legalisation--hebrew-v3/' |
    grep -vP 'guide2ee/undergrad' |
    grep -vP '(?:humour/TheEnemy/(?:The-Enemy-(?:English-)?rev|TheEnemy))' |
    grep -vP '(?:humour/by-others/(?:English-is-a-Crazy-Language|darien|hitchhiker|how-many-newsgroup-readers|oded-c|s-stands-for-simple|technion-bit-1|top-12-things-likely|was-the-death-star-attack|grad-student-jokes-from-jnoakes|the-fountainhead-starring-skull-force))' |
    grep -vP 'humour/bits/facts/(?:Chuck-Norris|XSLT)' |
    grep -vP 'humour/fortunes' |
    grep -vP 'humour/human-hacking/.*arabic' |
    grep -vP 'humour/human-hacking/human-hacking-field-guide/' |
    grep -vP 'humour/human-hacking/hebrew-v2' |
    grep -vP 'humour/humanity/ongoing-text-hebrew' |
    grep -vP 'lecture/Lambda-Calculus/slides/shriram\.scm' |
    grep -vP 'lecture/HTML-Tutorial/v1/xhtml1/hebrew' |
    grep -vP 'js/MathJax/(?:test|docs)/' |
    grep -vP 'dest/t2/philosophy/computers/high-quality-software/what-makes-software-high-quality' |
    grep -vP 'dest/t2/philosophy/computers/open-source/linus-torvalds-bus-factor/index' |
    grep -vP '\.raw\.html$' |
    grep -vP '\A\Qdest/t2/open-source/anti/TIOBE/Berke-Durak--anti-TIOBE--Mirror\E' |
    grep -vP '\A\Qdest/t2/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/\E' |
    grep -vP '\A\Qdest/t2/philosophy/philosophy/putting-all-cards-on-the-table-2013/DocBook5/\E' |
    grep -vP '\A\Qdest/t2/philosophy/philosophy/SummerNSA-2014-09-call-for-action/DocBook5/\E' |
    xargs perl bin/html-check-spelling-xmlp.pl |
    grep ':'
    # perl -lne 'print if /MathVentures\/3d.*\.xhtml/' |
exit 0
