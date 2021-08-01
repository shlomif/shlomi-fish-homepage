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
        input_fn = 'dest/post-incs/t2/philosophy/philosophy/' + \
            'putting-cards-on-the-table-2019-2020/index.xhtml'
        doc = self.doc(input_fn)

        doc.has_one(
            ".//h4[@id='fox-in-the-hens-coop' and " +
            "text()='The Fox in the Chickens Coop']"
        )
        doc.has_one(
            ".//section[header/h3[@id='hacking-heroism']]"
        )

    def test_share_this_url(self):
        input_fn = './dest/post-incs/t2/humour/bits/' + \
            'Atom-Text-Editor-edits-2_000_001-bytes/index.xhtml'
        doc = self.doc(input_fn)
        doc.has_one(
            ".//p[@class='share']/a[@href='" +
            "http://www.addtoany.com/share_save?linkurl=https%3A%2F%2F" +
            "www.shlomifish.org%2Fhumour%2Fbits%2FAtom-Text-Editor" +
            "-edits-2_000_001-bytes%2F&linkname=']"
        )

    def test_fanfic(self):
        input_fn = 'dest/post-incs/t2/philosophy/culture/' + \
            'case-for-commercial-fan-fiction/indiv-nodes/' + \
            'learning_more_from_inet_forums.xhtml'
        doc = self.doc(input_fn)
        xp = doc.xpath('//*/text()')
        self.assertEqual(
            [x for x in xp.xpath_results if (("b'" in x) or ("\\'" in x))],
            [],
            "no double quoting",
        )

    def test_root_page_has_hosting_link(self):
        input_fn = './dest/post-incs/t2/index.xhtml'
        self.doc(input_fn).has_one(
            ".//footer//a[@href = 'meta/hosting/#hostgator']/"
            + "img[@src='images/hostgator.png' and @alt='Hosted at HostGator']"
        )

    def test_site_map(self):
        input_fn = './dest/post-incs/t2/site-map/index.xhtml'
        self.doc(input_fn).has_one(
            ".//div[@class='sitemap']/ul/li[a[@href='../humour/']]" +
            "/ul/li/a[@href='../humour/aphorisms/']"
        )

    def test_factoids_fortune_page__h3_elem(self):
        input_fn = './dest/post-incs/t2/humour/fortunes/shlomif-factoids.html'
        self.doc(input_fn).has_one(
            ".//h3[@id='shlomif-fact-xena-1' and " +
            "text()='Shlomi Fish’s Xena the Warrior Princess Fact #1']"
        )

    def test_hebrew_site_map(self):
        input_fn = './dest/post-incs/t2/site-map/hebrew/index.xhtml'
        doc = self.doc(input_fn)

        sect = ".//section[header/*/@id='sitemap']"
        doc.has_one(
            sect +
            "/ul/li[a[@href='../../humour/']]" +
            ""
            )

        doc.has_one(
            sect +
            "/ul/li[a[@href='../../humour/']]" +
            "/ul/li[a[@href='../../humour/stories/']]" +
            "/ul/li[a[@href='../../humour/TheEnemy/']]" +
            "/ul/li[a[contains(@href, " +
            "'../../humour/TheEnemy/The-Enemy-Hebrew')]]" +
            ""
            )

    def test_faq_inner_links(self):
        input_fn = \
            './dest/post-incs/t2/meta/FAQ/atheism_can_be_a_religion.xhtml'
        doc = self.doc(input_fn)
        doc.has_count(".//a[@href='./#religious_belief']", 2)

    def test_rindolfism(self):
        input_fn = \
            './dest/post-incs/t2/me/rindolfism/index.xhtml'
        doc = self.doc(input_fn)
        doc.has_none(
            ".//section[header/*/@id='neo_semitism']" +
            "/section[header/*/@id='rindolfism_canon']")
        doc.has_one(
            ".//section[header/*/@id='rindolfism']" +
            "/section[header/*/@id='rindolfism_canon']")


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
