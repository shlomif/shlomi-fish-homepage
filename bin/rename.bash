#! /bin/bash
#
# rename.bash
# Copyright (C) 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
orig="$1"
wfn="${orig%%.wml}.tt2"
wfn="src/${wfn##t2/}"
git mv "$orig" "$wfn"
perl -i -0777 -p bin/wml2tt.pl "$wfn"
