#! /usr/bin/env bash
#
# bin/mirror-using-wget.bash
# Copyright (C) 2024 Shlomi Fish < https://www.shlomifish.org/ >
#
# Distributed under the terms of the MIT license.
#

# On https://github.com/shlomif/shlomif-computer-settings/blob/master/shlomif-settings/apache/httpd/minimal-config/fedora/localhost-homepage-httpd.conf
# one can find a sample apache httpd ( v 2.4.x ) configuration that can be used
# to host the mirrored copy (after some tweaks).

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
