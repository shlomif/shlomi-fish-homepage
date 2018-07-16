#! /bin/bash
#
# spell.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#

unalias l
l()
{
    make
    bin/spell-checker-iface > foo.txt
    perl bin/extract-spelling-errors.pl > y.txt
}
