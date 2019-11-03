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

XML_NS = "{http://www.w3.org/XML/1998/namespace}"


def main():
    root = etree.parse("./lib/factoids/shlomif-factoids-lists.xml")
    for list_elem in root.xpath("./list"):
        print(list_elem.get("{}id".format(XML_NS)))


main()
