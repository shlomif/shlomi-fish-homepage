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


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
