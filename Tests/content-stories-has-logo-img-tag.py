#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import unittest

from lxml import etree


class MyTests(unittest.TestCase):
    def test_main(self):
        input_fn = './dest/post-incs/t2/humour/Selina-Mandrake/index.xhtml'
        root = etree.HTML(open(input_fn, "rb").read())
        self.assertTrue(len(root.xpath(
            ".//img[@id='selina_mandrake_logo' and " +
            "@src='images/Green-d10-dice.png']"
            )) == 1)


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
