#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import html_unit_test


class MyTests:
    def main(self):
        import sys
        for input_fn in sys.argv[1:]:
            # doc = self.doc(input_fn)
            doc = html_unit_test.HtmlTestsDoc(self, input_fn)
            results = doc.xpath('//*/@id').xpath_results
            found = set()
            for x in results:
                if x in found:
                    print("{}: [ {} ]".format(input_fn, x))
                    raise BaseException(x)
                found.add(x)
            print("{}:".format(input_fn), sorted(list(results)))


if __name__ == '__main__':
    MyTests().main()
    if False:
        from pycotap import TAPTestRunner
        import unittest
        suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
        TAPTestRunner().run(suite)
