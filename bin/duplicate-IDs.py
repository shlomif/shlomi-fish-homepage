#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import html_unit_test
import os
from os.path import join


def _find_htmls(root):
    """docstring for find_htmls"""
    for dirpath, _, fns in os.walk(root):
        for fn in fns:
            if fn.endswith(('.html', '.xhtml')):
                path = join(dirpath, fn)
                yield path


def _test_finder():
    for x in _find_htmls(root="dest/post-incs/t2/"):
        print(x)


# _test_finder()


class MyTests:
    def main(self):
        verdict = {}
        for input_fn in _find_htmls(root="dest/post-incs/t2/"):
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
                verdict[input_fn] = dups
                # raise BaseException(x)
            # print("{}:".format(input_fn), sorted(list(results)))
        ret = (len(verdict) == 0)
        assert ret
        return ret, verdict


if __name__ == '__main__':
    MyTests().main()
    if False:
        from pycotap import TAPTestRunner
        import unittest
        suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
        TAPTestRunner().run(suite)
