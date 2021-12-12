#!/bin/bash
#
# install-npm-deps.sh
# Copyright (C) 2018 shlomif <shlomif@cpan.org>
#
# Distributed under the MIT license.
#
(
set -e
npm install
PATH="$PATH:$PWD/node_modules/.bin"
bower install
for dir in bower_components node_modules
do
    (cd "$dir" ; git init . )
done
)
