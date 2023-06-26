#! /usr/bin/env bash
#
# test-captioned-image-gen.bash
# Copyright (C) 2021 Shlomi Fish < https://www.shlomifish.org/ >
#
# Distributed under the terms of the MIT license.
#
(
    set -e -x
    test -e ../trunk
    test "trunk--clones" = "$(basename "$(pwd)")"
    img="Captioned-Image-Badass-Schwarzenegger"
    test -d "$img" && rm -fr "$img"
    python3 "$trunk"/bin/generate_captioned_image.py --process none
    (
        cd "$img"
        gmake
        git i
        inkscape *.svg
    )
)
