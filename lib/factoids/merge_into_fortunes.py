#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""

"""

from lxml import etree

root = etree.parse("./lib/factoids/shlomif-factoids-lists.xml")
for i in root.xpath("./list"):
    print(i.get("title"))
