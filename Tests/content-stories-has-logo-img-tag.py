#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import unittest

from lxml import html


class MyTests(unittest.TestCase):
    def test_main(self):
        input_fn = './dest/post-incs/t2/humour/Selina-Mandrake/index.xhtml'
        root = html.parse(input_fn)
        self.assertEqual(len(root.xpath(
            ".//img[@id='selina_mandrake_logo' and " +
            "@src='images/Green-d10-dice.webp']"
            )), 1)

    def test_factoids(self):
        input_fn = './dest/post-incs/t2/humour/fortunes/shlomif-factoids.html'
        root = html.parse(input_fn)
        self.assertEqual(len(root.xpath(
            ".//h3[@id='shlomif-fact-xena-1' and " +
            "text()='Shlomi Fish’s Xena the Warrior Princess Fact #1']"
            )), 1)

    def test_hhgg_st_tng(self):
        input_fn = (
            './dest/post-incs/t2/humour/' +
            'by-others/hitchhiker-guide-to-star-trek-tng-htmlised.html'
        )
        root = html.parse(input_fn)
        self.assertEqual(len(root.xpath(
            ".//section[header/h2[@id='about']]/descendant::p" +
            "[contains(text(),'This is an HTMLised version')]")),
            1,
            "describes HTMLised in about",
            )


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
