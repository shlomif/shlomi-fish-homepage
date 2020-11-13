#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

"""

"""

import unittest

from lxml import html


class HtmlTestsDocQuery:
    """docstring for HtmlTestsDocQuery"""
    def __init__(self, doc, xpath_results):
        self.doc = doc
        self.xpath_results = xpath_results

    def __len__(self):
        """docstring for __len__"""
        return len(self.xpath_results)


class HtmlTestsDoc:
    """docstring for HtmlTestsDoc"""
    def __init__(self, harness, fn):
        self.harness = harness
        self.fn = fn
        self.root = html.parse(fn)

    def xpath(self, xpath_s):
        return HtmlTestsDocQuery(self, self.root.xpath(xpath_s))

    def has_one(self, xpath_s):
        """docstring for has_one"""
        self.harness.assertEqual(len(self.xpath(xpath_s)), 1)


class TestCase(unittest.TestCase):
    def doc(self, path):
        return HtmlTestsDoc(self, path)
