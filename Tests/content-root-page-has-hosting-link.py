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
        input_fn = './dest/post-incs/t2/index.xhtml'
        return self.doc(input_fn).has_one(
            ".//footer//a[@href = 'meta/hosting/#hostgator']/"
            + "img[@src='images/hostgator.png' and @alt='Hosted at HostGator']"
        )

    def test_site_map(self):
        input_fn = './dest/post-incs/t2/site-map/index.xhtml'
        return self.doc(input_fn).has_one(
            ".//div[@class='sitemap']/ul/li[a[@href='../humour/']]" +
            "/ul/li/a[@href='../humour/aphorisms/']"
        )

    def test_hebrew_site_map(self):
        input_fn = './dest/post-incs/t2/site-map/hebrew/index.xhtml'
        doc = self.doc(input_fn)

        doc.has_one(
            ".//div[@class='sitemap']/ul/li[a[@href='../../humour/']]" +
            ""
            )

        doc.has_one(
            ".//div[@class='sitemap']/ul/li[a[@href='../../humour/']]" +
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
