#! /usr/bin/env bash
#
# bin/mirror-using-wget.bash
# Copyright (C) 2024 Shlomi Fish < https://www.shlomifish.org/ >
#
# Distributed under the terms of the MIT license.
#

# wget --mirror --convert-links 'http://localhost/shlomif/homepage-local'

set -e -x

siteurl="http://127.0.0.1:2400/sites/hp/"
excludes=()
prod="true"

if test "${prod}" = "true"
then
    siteurl="https://www.shlomifish.org/"
    excludes=("--exclude-directories=/Files")
fi

wget2 -r -p --no-parent --default-page="index.xhtml" ${excludes[@]} "${siteurl}"
