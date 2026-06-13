#! /usr/bin/env bash
#
# Extract a frame from a Sesame Street skit.
#
# Copyright (C) 2026 Shlomi Fish < https://www.shlomifish.org/ >
#
# Distributed under the terms of the MIT license.
#

# Based on https://github.com/rendi-api/ffmpeg-cheatsheet
# https://github.com/rendi-api/ffmpeg-cheatsheet/commit/aa994435ab7cd8483ffe733c11af70fe3fdd0b35
#
# Thanks!

set -e -x
ffmpeg -i ~/Download/Video/"Sesame Street Newsflash： The Magic Mirror [x_hoV9pCoXA].mkv" -ss 00:01:31 -frames:v 1 output_thumbnail.png
