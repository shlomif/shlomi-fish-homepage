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
    local bn="`basename "$fn"`"
    git mv lib/docbook/4/xml/"$bn" lib/docbook/5/xml/
    xsltproc /home/shlomif/Download/Arcs/db4-upgrade.xsl lib/docbook/5/xml/"$bn" > ytemp
    perl -lapE 's/[ \t]+$//' < ytemp > lib/docbook/5/xml/"$bn"
    git add lib/docbook/5/xml/"$bn"
    )
}
