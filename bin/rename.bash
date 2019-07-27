#! /bin/bash
#
# rename.bash
# Copyright (C) 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
for orig in "$@"
do
    wfn="${orig%%.wml}.tt2"
    wfn="src/${wfn##t2/}"
    mkdir -p "$(dirname "$wfn")"
    git mv "$orig" "$wfn"
    perl -i -0777 -p bin/wml2tt.pl "$wfn"
done
