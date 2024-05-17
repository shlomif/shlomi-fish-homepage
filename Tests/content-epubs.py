#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import unittest
from zipfile import ZipFile

from lxml import etree

XML_NS = "{http://www.w3.org/XML/1998/namespace}"
ns = {"xml": XML_NS, "ncx": "http://www.daisy.org/z3986/2005/ncx/", }


class MyTests(unittest.TestCase):
    def test_main(self):
        zip_obj = ZipFile(
            './dest/post-incs/t2/humour/' +
            'So-Who-The-Hell-Is-Qoheleth/' +
            'So-Who-the-Hell-is-Qoheleth.epub', 'r')
        with zip_obj.open("OEBPS/toc.ncx") as fh:
            xml = fh.read()
        root = etree.XML(xml)
        self.assertEqual(len(root.xpath(
            ".//ncx:navMap/ncx:navPoint/ncx:navLabel/" +
            "ncx:text[text()='Introducing Josephus']",
            namespaces=ns,
            )),
            1
        )


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
