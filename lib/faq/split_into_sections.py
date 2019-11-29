#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""
Merge / propagate recent items from the
lib/factoids/shlomif-factoids-lists.xml file
into t2/humour/fortunes/shlomif-factoids.xml .

DRY - https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
"""

import re

from lxml import etree
from lxml.html import XHTML_NAMESPACE

XHTML_NS = XHTML_NAMESPACE
XML_NS = "{http://www.w3.org/XML/1998/namespace}"
ns = {
    "xhtml": XHTML_NS,
    "xml": XML_NS,
}
FULL_NAMES = {"chuck": "Chuck Norris",
              "emma-watson": "Emma Watson",
              "nsa": "NSA",
              "taylor-swift": "Taylor Swift", }

ID_IS_FACTOID_RE = re.compile("^[a-z\\-]+-fact-([a-z\\-]+)-([0-9]+)$")
BASENAME_EXTRACT_RE = re.compile('^([a-z_\\-]*)_facts$')


class FortunesMerger:
    def __init__(self, input_fn, merge_into_fn):
        self.input_fn = input_fn
        self.root = etree.parse(input_fn)

    def process(self):
        for list_elem in self.root.xpath(
                "//xhtml:div[@class='faq fancy_sects lim_width wrap-me']" +
                "//xhtml:section", namespaces=ns):
            id_ = list_elem.xpath("./xhtml:header/*/@id", namespaces=ns)
            print(id_)
            # print(etree.tostring(id_))


def main():
    xml_propagator = FortunesMerger(
        "./dest/post-incs/t2/meta/FAQ/index.xhtml",
        "./t2/humour/fortunes/proto--shlomif-factoids.xml")
    xml_propagator.process()


main()
