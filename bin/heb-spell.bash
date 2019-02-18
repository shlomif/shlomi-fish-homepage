#! /bin/bash
#
# hebspell.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#

unalias l
l()
{
    make
    bin/heb-spell-checker-iface > foo.txt
    perl bin/extract-spelling-errors.pl > y.txt
}
e()
{
    gvim -o foo.txt y.txt lib/hunspell/hebrew-whitelist1.txt
}
