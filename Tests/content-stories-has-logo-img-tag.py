#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import unittest

import html_unit_test


class MyTests(html_unit_test.TestCase):
    def test_main(self):
        input_fn = './dest/post-incs/t2/humour/Selina-Mandrake/index.xhtml'
        return self.doc(input_fn).has_one(
            ".//img[@id='selina_mandrake_logo' and " +
            "@src='images/Green-d10-dice.webp']"
        )

    def test_factoids(self):
        input_fn = './dest/post-incs/t2/humour/fortunes/shlomif-factoids.html'
        return self.doc(input_fn).has_one(
            ".//h3[@id='shlomif-fact-xena-1' and " +
            "text()='Shlomi Fish’s Xena the Warrior Princess Fact #1']"
        )

    def test_factoids_main_page(self):
        input_fn = './dest/post-incs/t2/humour/bits/facts/index.xhtml'
        doc = self.doc(input_fn)
        res = doc.xpath(
            ".//section[@class='h3 facts']"
        )
        self.assertTrue((len(res) > 6), "len(facts)")
        for el in res.xpath_results:
            a_el = el.xpath(
                "./header/h3/a"
            )
            self.assertEqual(len(a_el), 1, "len")
            self.assertTrue(
                a_el[0].get("href").endswith("/"),
                "trailing slash for directory link"
            )
            self.assertFalse(
                a_el[0].text.endswith("[Satire]"),
                "[Satire] title",
            )

    def test_hhgg_st_tng(self):
        input_fn = (
            './dest/post-incs/t2/humour/' +
            'by-others/hitchhiker-guide-to-star-trek-tng-htmlised.html'
        )
        return self.doc(input_fn).has_one(
            ".//section[header/h2[@id='about']]/descendant::p" +
            "[contains(text(),'This is an HTMLised version')]",
            "describes HTMLised in about",
            )

    def test_road2heaven(self):
        input_fn = './dest/post-incs/t2/humour/RoadToHeaven/abstract.xhtml'
        return self.doc(input_fn).has_one(
            ".//li[contains(" +
            "text(),'החבר לשעבר מחליט שקבוצה מייצגת של חברים לשעבר')]"
        )


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
