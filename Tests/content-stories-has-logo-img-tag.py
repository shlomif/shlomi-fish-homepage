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
        self.doc(input_fn).has_one(
            ".//img[@id='selina_mandrake_logo' and " +
            "@src='images/Green-d10-dice.webp']"
        )

    def test_factoids(self):
        input_fn = './dest/post-incs/t2/humour/fortunes/shlomif-factoids.html'
        self.doc(input_fn).has_one(
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
        self.doc(input_fn).has_one(
            ".//section[header/h2[@id='about']]/descendant::p" +
            "[contains(text(),'This is an HTMLised version')]",
            "describes HTMLised in about",
            )

    def test_road2heaven(self):
        input_fn = './dest/post-incs/t2/humour/RoadToHeaven/abstract.xhtml'
        self.doc(input_fn).has_one(
            ".//li[contains(" +
            "text(),'החבר לשעבר מחליט שקבוצה מייצגת של חברים לשעבר')]"
        )

    def test_tagline_on_stories_page(self):
        input_fn = './dest/post-incs/t2/humour/stories/index.xhtml'
        self.doc(input_fn).has_one(
            ".//article[@class='story' and " +
            ".//h3/@id='summerschool-at-the-nsa']/p[@class='tagline' " +
            "and contains(text(), 'As the sling shoots')]")

    def test_anchor_link(self):
        input_fn = (
            './dest/post-incs/t2/humour/Terminator/Liberation/' +
            'indiv-nodes/hamlet-parody-Cher-parody.xhtml'
        )
        self.doc(input_fn).has_one(
            ".//a[@href='../ongoing-text.html#emulating-arnie-as-hamlet'"
            "and text()='the Hamlet parody scene']"
        )

    def _factoids_check_helper(self, input_fn, htmlid):
        self.doc(input_fn).has_one(
            ".//a[contains(@href, 'humour/fortunes/shlomif-factoids.html#"
            + htmlid + "')"
            + "and text()='These factoids in XML-Grammar-Fortune format']"
        )

    def test_chuck_factoids_link(self):
        input_fn = (
            './dest/post-incs/t2/humour/bits/facts/Chuck-Norris/index.xhtml'
        )
        self._factoids_check_helper(
            input_fn=input_fn, htmlid='shlomif-fact-chuck-1'
        )

    def test_sglau_factoids_link(self):
        input_fn = (
            './dest/post-incs/t2/humour/bits/facts/Summer-Glau/index.xhtml'
        )
        self._factoids_check_helper(
            input_fn=input_fn, htmlid='shlomif-fact-sglau-1'
        )

    def test_emma_w_factoids_link(self):
        input_fn = (
            './dest/post-incs/t2/humour/bits/facts/Emma-Watson/index.xhtml'
        )
        self._factoids_check_helper(
            input_fn=input_fn, htmlid='shlomif-fact-emma-watson-1'
        )


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
