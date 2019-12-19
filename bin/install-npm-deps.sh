#!/bin/bash
#
# install-npm-deps.sh
# Copyright (C) 2018 shlomif <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
    # hackmyresume \
(
set -e -x
npm install
bower install
exit

########### Not needed due to package.json .
#     camel-case \
#     eslint \
#     eslint-config-google \
#     html-minifier \
#     jquery \
#     param-case \
#     prettier \
#     sass \
#     uglify-es \

)
