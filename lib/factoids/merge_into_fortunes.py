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
ns = {"xml": XML_NS, }


def main():
    root = etree.parse("./lib/factoids/shlomif-factoids-lists.xml")
    for list_elem in root.xpath("./list"):
        list_id = list_elem.get("{}id".format(XML_NS))
        found_fact = list_elem.xpath("./fact[@xml:id = '{}']".format(
            list_id + '--startaddmore'), namespaces=ns)
        if found_fact:
            print(list_id)
            fact = found_fact[0]
            while fact:
                print(etree.tostring(fact))
                fact = fact.getnext()


main()
