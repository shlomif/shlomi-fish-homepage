#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

from html_unit_test import HtmlCheckDuplicateIDs


if __name__ == '__main__':
    HtmlCheckDuplicateIDs().check_dir_tree(root="dest/post-incs/t2/")
    if False:
        from pycotap import TAPTestRunner
        import unittest
        suite = unittest.TestLoader().loadTestsFromTestCase(
            HtmlCheckDuplicateIDs
        )
        TAPTestRunner().run(suite)
