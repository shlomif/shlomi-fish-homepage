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
        return self.doc(input_fn).has_one(
            ".//h4[@id='fox-in-the-hens-coop' and " +
            "text()='The Fox in the Chickens Coop']"
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


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
