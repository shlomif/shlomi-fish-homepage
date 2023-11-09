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
            doc = html_unit_test.HtmlTestsDoc(None, input_fn)
            results = doc.xpath('//*/@id').xpath_results
            found = set()
            dups = set()
            for x in results:
                if x in found:
                    # print("{}: [ {} ]".format(input_fn, x))
                    dups.add(x)
                else:
                    found.add(x)
            if len(dups) > 0:
                print("DUPLICATES! {}:".format(input_fn), sorted(list(dups)))
                # raise BaseException(x)
            # print("{}:".format(input_fn), sorted(list(results)))


if __name__ == '__main__':
    MyTests().main()
    if False:
        from pycotap import TAPTestRunner
        import unittest
        suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
        TAPTestRunner().run(suite)
