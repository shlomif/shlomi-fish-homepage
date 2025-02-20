#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2025 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

"""

"""
import os
import re


for bef in [True]:
    for mid in [False]:
        for aft in [False]:
            def repl(m):
                return " " * bef + "/" + " " * mid + ">" + " " * aft
            repl_str = repl(None)


def process_file(fn):
    with open(fn, 'rt') as infh:
        src = infh.read()

    newtxt = re.sub("\\s*/\\s*>\\s*", repl_str, src)

    with open(fn, 'wt') as o:
        o.write(newtxt)


def calc_fn(dirpath):
    total_fns = []
    from os.path import join
    for root, dirs, files in os.walk(dirpath):
        for name in files:
            fn = join(root, name)
            if fn.endswith(".html") or fn.endswith(".xhtml"):
                total_fns.append(fn)
    return total_fns


dirpath = 'dest/post-incs/t2/philosophy/philosophy/'
total_fns = calc_fn(dirpath)
for fn in total_fns:
    process_file(fn)
