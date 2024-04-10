#! /usr/bin/env bash
#
# make-sea-webp.bash
# Copyright (C) 2024 Shlomi Fish < https://www.shlomifish.org/ >
#
# Distributed under the terms of the MIT license.
#

set -e -x
src="8541049401_7895822254_o.jpg"
dest="shlomif-near-the-sea-2013-03-09-800h.webp"
gm convert "${src}" -auto-orient -geometry x800 "${dest}"
sha256sum "${dest}" >> log.txt
gwenview "${dest}"
