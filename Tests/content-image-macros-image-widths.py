#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import re
import unittest

from PIL import Image

from lxml import etree


# the WIDTH is subject to update in the future
WIDTH = 600


class MyTests(unittest.TestCase):
    def test_main(self):
        input_fn = './dest/post-incs/t2/humour/image-macros/index.xhtml'
        root = etree.HTML(open(input_fn, "rb").read())
        imgs = root.xpath(".//article/img")
        self.assertTrue(len(imgs) > 5)
        for img in imgs:
            src = img.get("src")
            self.assertTrue(src)
            m = re.match(
                "^\\.\\./\\.\\./(humour/images/[A-Za-z0-9_.\\-]+)$", src)
            self.assertTrue(m)
            path = m[1]
            self.assertTrue(re.match(".*\\.webp$", path))
            self.assertEqual(
                Image.open("./dest/post-incs/t2/" + path).size[0],
                WIDTH,
                "image {} has WIDTH={}".format(path, WIDTH)
                )


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
