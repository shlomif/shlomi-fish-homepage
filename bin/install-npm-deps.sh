#!/bin/bash
#
# install-npm-deps.sh
# Copyright (C) 2018 shlomif <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
(
set -e -x
npm install
PATH="$PATH:`pwd`/node_modules/.bin"
bower install
)
