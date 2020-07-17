#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under the MIT license.

import os

import shlomif_epub_maker
shlomif_epub_maker._my_amend_epub(os.getenv('DFN'))
