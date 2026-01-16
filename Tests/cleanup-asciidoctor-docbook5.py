#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import unittest

from lxml import etree
from html_unit_test import HtmlTestsDoc

XML_NS = "{http://www.w3.org/XML/1998/namespace}"
ns = {"xml": XML_NS, "ncx": "http://www.daisy.org/z3986/2005/ncx/", }


class MyTests(unittest.TestCase):
    def test_main(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            fn = tmp + "/" + "out.docbook5.xml"

            xml_filename = "Tests/data/love-life-policy.docbook5.xml"
            xsl_filename = "bin/clean-up-asciidoctor-docbook5--take2.xslt"

            dom = etree.parse(xml_filename)
            xslt = etree.parse(xsl_filename)
            transform = etree.XSLT(xslt)
            newdom = transform(dom)
            with open(fn, "wb") as fh:
                fh.write(etree.tostring(newdom, pretty_print=True))

            root = HtmlTestsDoc(harness=self, fn=fn, filetype='docbook5')
            root.has_one("//db:info/db:title[contains(text(), 'Meeting')]")
            root.has_one(
                "//db:listitem/db:para[contains(text(), 'call the children')]"
            )


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
