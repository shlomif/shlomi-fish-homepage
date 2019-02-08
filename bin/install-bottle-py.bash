#! /bin/bash
#
# install-bottle-py.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
set -e -x
dest="t2/humour/fortunes/bottle.py"
wget -O "$dest" https://bottlepy.org/bottle.py
touch "$dest"
