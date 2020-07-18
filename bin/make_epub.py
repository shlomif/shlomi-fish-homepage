#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under the MIT license.

import sys

import shlomif_epub_maker

assert sys.argv.pop(1) == "--output"
dfn = sys.argv.pop(1)
jsonfn = sys.argv.pop(1)
shlomif_epub_maker._my_amend_epub(dfn, jsonfn)
