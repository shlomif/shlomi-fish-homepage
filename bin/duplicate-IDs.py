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
        """docstring for main"""
        return self.check_files(
            paths_list=_find_htmls(root="dest/post-incs/t2/")
        )

    def check_files(self, paths_list):
        offending_files = {}
        for input_fn in paths_list:
            # doc = self.doc(input_fn)
            doc = html_unit_test.HtmlTestsDoc(None, input_fn)
            ids_list = doc.xpath('//*/@id').xpath_results
            found = set()
            dups = set()
            for x in ids_list:
                if x in found:
                    # print("{}: [ {} ]".format(input_fn, x))
                    dups.add(x)
                else:
                    found.add(x)
            if len(dups) > 0:
                print("DUPLICATES! {}:".format(input_fn), sorted(list(dups)))
                offending_files[input_fn] = dups
                # raise BaseException(x)
            # print("{}:".format(input_fn), sorted(list(ids_list)))
        ret = (len(offending_files) == 0)
        assert ret
        return ret, offending_files


if __name__ == '__main__':
    MyTests().main()
    if False:
        from pycotap import TAPTestRunner
        import unittest
        suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
        TAPTestRunner().run(suite)
