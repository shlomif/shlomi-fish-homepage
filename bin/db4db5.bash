#! /bin/bash
#
# db4db5.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#


ff()
{
    (
    set -x -e
    local fn="$1"
    shift
    local bn="`basename "$fn"`"
    local nbn="${1:-$bn}"
    shift
    git mv lib/docbook/4/xml/"$bn" lib/docbook/5/xml/"$nbn"
    xsltproc /home/shlomif/Download/Arcs/db4-upgrade.xsl lib/docbook/5/xml/"$nbn" > ytemp
    perl -lapE 's/[ \t]+$//' < ytemp > lib/docbook/5/xml/"$nbn"
    git add lib/docbook/5/xml/"$nbn"
    )
}
