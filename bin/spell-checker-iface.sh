#!/bin/bash
find dest/t2-homepage/ -name '*.html' -or -name '*.xhtml' |
    ( LC_ALL=C sort  ) |
    perl -lne 'print if /MathVentures\/3d.*\.xhtml/' |
    xargs perl bin/html-check-spelling-xmlp.pl |
    grep ':'
