#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import unittest

from lxml import etree

XML_NS = "{http://www.w3.org/XML/1998/namespace}"
XHTML_NS = "{http://www.w3.org/1999/xhtml}"
ns = {"xml": XML_NS, "xhtml": XHTML_NS, }
FULL_NAMES = {"chuck": "Chuck Norris",
              "emma-watson": "Emma Watson",
              "nsa": "NSA",
              "taylor-swift": "Taylor Swift", }


class MyTests(unittest.TestCase):
    def test_main(self):
        input_fn = './dest/post-incs/t2/humour/Selina-Mandrake/index.xhtml'
        root = etree.HTML(open(input_fn, "rb").read())
        self.assertTrue(len(root.xpath(
            (".//*[name()='img' and @id='selina_mandrake_logo' and " +
             "@src='images/Green-d10-dice.png']"
             ), namespaces=ns)) == 1)


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
